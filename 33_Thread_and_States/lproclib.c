#pragma comment(lib, "../ThirdParty/lib/lua.lib")
#pragma comment(lib, "../ThirdParty/lib/pthreadVC3.lib")
#include <pthread.h>
#include <string.h>
#include "lua.h"
#include "lualib.h"
#include "lauxlib.h"

typedef struct Proc
{
    lua_State *L;
    pthread_t thread;
    pthread_cond_t cond;
    const char *channel;
    struct Proc *prev, *next;
} Proc;

static Proc *waittosend = NULL;
static Proc *waittorecv = NULL;

static pthread_mutex_t kernel_access = PTHREAD_MUTEX_INITIALIZER;

static Proc *getself(lua_State *L)
{
    lua_getfield(L, LUA_REGISTRYINDEX, "_SELF");
    Proc *p = (Proc *)lua_touserdata(L, -1);
    lua_pop(L, 1);
    return p;
}

static int copyvalue(lua_State *send, lua_State *recv, int fromidx)
{
    int type = lua_type(send, fromidx);
    switch (type)
    {
    case LUA_TBOOLEAN:
    {
        lua_pushboolean(recv, lua_toboolean(send, fromidx));
        break;
    }
    case LUA_TNUMBER:
    {
        if (lua_isinteger(send, fromidx))
            lua_pushinteger(recv, lua_tointeger(send, fromidx));
        else
            lua_pushnumber(recv, lua_tonumber(send, fromidx));
        break;
    }
    case LUA_TSTRING:
    {
        lua_pushstring(recv, lua_tostring(send, fromidx));
        break;
    }
    default:
    {
        return 0;
    }
    }
    return 1;
}
static void copytable(lua_State *send, lua_State *recv, int sendi)
{
    if (sendi < 0)
        sendi = lua_gettop(send) + sendi + 1;
    lua_newtable(recv);
    int recvi = lua_gettop(recv);

    lua_pushnil(send);
    while (lua_next(send, sendi) != 0)
    {
        // send : ..., table, ..., key, value
        // index:        t         -2    -1

        if (!copyvalue(send, recv, -2))
        {
            if (lua_type(send, -2) == LUA_TTABLE)
            {
                copytable(send, recv, lua_gettop(send) - 1);
            }
            else
            {
                lua_pushnil(recv);
            }
        };
        if (!copyvalue(send, recv, -1))
        {
            if (lua_type(send, -1) == LUA_TTABLE)
            {
                copytable(send, recv, lua_gettop(send));
            }
            else
            {
                lua_pushnil(recv);
            }
        };
        lua_settable(recv, recvi);
        // send : ..., table, ..., key
        // index:        t         -1
        lua_pop(send, 1);
    }
}

static void movevalues(lua_State *send, lua_State *recv)
{
    int n = lua_gettop(send);
    luaL_checkstack(recv, n, "too many results");
    for (size_t i = 3; i <= n; i++)
    {
        if (!copyvalue(send, recv, i))
        {
            if (lua_type(send, i) == LUA_TTABLE)
                copytable(send, recv, i);
            else
                lua_pushnil(recv);
        }
    }
}

static Proc *searchmatch(const char *channel, Proc **list)
{
    for (Proc *node = *list; node != NULL; node = node->next)
    {
        if (strcmp(channel, node->channel) == 0)
        {
            if (*list == node)
            {
                *list = (node->next == node) ? NULL : node->next;
            }
            else
            {
                node->prev->next = node->next;
                node->next->prev = node->prev;
            }
            return node;
        }
    }
    return NULL;
}

static void waitonlist(lua_State *L, const char *channel, Proc **list, time_t waitseconds)
{
    Proc *p = getself(L);
    if (*list == NULL)
    {
        *list = p;
        p->prev = p;
        p->next = p;
    }
    else
    {
        p->prev = (*list)->prev;
        p->next = *list;
        p->prev->next = p;
        p->next->prev = p;
    }
    p->channel = channel;
    do
    {
        const struct timespec to = {time(NULL) + waitseconds, 0};
        int err = pthread_cond_timedwait(&p->cond, &kernel_access, &to);
        if (err == ETIMEDOUT)
        {
            // remove self from list
            if (*list == p)
            {
                *list = (p->next == p) ? NULL : p->next;
            }
            else
            {
                p->prev->next = p->next;
                p->next->prev = p->prev;
            }
            break;
        }
    } while (p->channel);
}

static int ll_send(lua_State *L)
{
    const char *channel = luaL_checkstring(L, 1);
    time_t waitseconds = luaL_checkinteger(L, 2);
    pthread_mutex_lock(&kernel_access);
    Proc *p = searchmatch(channel, &waittorecv);
    if (p)
    {
        movevalues(L, p->L);
        p->channel = NULL;
        pthread_cond_signal(&p->cond);
    }
    else
    {
        waitonlist(L, channel, &waittosend, waitseconds);
    }
    pthread_mutex_unlock(&kernel_access);
    return 0;
}

static int ll_recv(lua_State *L)
{
    const char *channel = luaL_checkstring(L, 1);
    time_t waitseconds = luaL_checkinteger(L, 2);
    lua_settop(L, 2);
    pthread_mutex_lock(&kernel_access);
    Proc *p = searchmatch(channel, &waittosend);
    if (p)
    {
        movevalues(p->L, L);
        p->channel = NULL;
        pthread_cond_signal(&p->cond);
    }
    else
    {
        waitonlist(L, channel, &waittorecv, waitseconds);
    }
    pthread_mutex_unlock(&kernel_access);
    return lua_gettop(L) - 2;
}

static void *ll_thread(void *arg);

static int ll_start(lua_State *L)
{
    pthread_t thread;
    const char *chunk = luaL_checkstring(L, 1);
    lua_State *L1 = luaL_newstate();
    if (L1 == NULL)
        luaL_error(L, "unable to create new state");
    if (luaL_loadstring(L1, chunk) != 0)
        luaL_error(L, "error in thread body: %s", lua_tostring(L1, -1));
    if (pthread_create(&thread, NULL, ll_thread, L1) != 0)
        luaL_error(L, "unable to create new thread");
    pthread_detach(thread);
    return 0;
}

static int ll_exit(lua_State *L)
{
    pthread_exit(NULL);
    return 0;
}

__declspec(dllexport) int luaopen_lproclib(lua_State *L)
{
    static const struct luaL_Reg lib_funcs[] = {
        {"start", ll_start},
        {"send", ll_send},
        {"recv", ll_recv},
        {"exit", ll_exit},
        {NULL, NULL}};
    luaL_newlib(L, lib_funcs);
    return 1;
}

static void *ll_thread(void *arg)
{
    lua_State *L = (lua_State *)arg;
    luaL_openlibs(L);
    luaL_requiref(L, "lproclib", luaopen_lproclib, 1);
    lua_pop(L, 1);

    Proc *self = (Proc *)lua_newuserdata(L, sizeof(Proc));
    lua_setfield(L, LUA_REGISTRYINDEX, "_SELF");
    self->L = L;
    self->channel = NULL;
    self->thread = pthread_self();
    pthread_cond_init(&self->cond, NULL);

    if (lua_pcall(L, 0, 0, 0) != 0)
        fprintf(stderr, "thread error: %s", lua_tostring(L, -1));
    pthread_cond_destroy(&getself(L)->cond);
    lua_close(L);
    return NULL;
};

// cmd /k """path/to/vcvars64.bat"" x64 && cl.exe lproclib.c -I ../ThirdParty/include/ -link -DLL -OUT:lproclib.dll && del lproclib.obj lproclib.lib lproclib.exp && exit || exit"
