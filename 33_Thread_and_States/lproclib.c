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

static void movevalues(lua_State *send, lua_State *recv)
{
    int n = lua_gettop(send);
    luaL_checkstack(recv, n, "too many results");
    for (size_t i = 2; i <= n; i++)
    {
        int type = lua_type(send, i);
        switch (type)
        {
        case LUA_TBOOLEAN:
        {
            lua_pushboolean(recv, lua_toboolean(send, i));
            break;
        }
        case LUA_TNUMBER:
        {
            lua_pushnumber(recv, lua_tonumber(send, i));
            break;
        }
        case LUA_TSTRING:
        {
            lua_pushstring(recv, lua_tostring(send, i));
            break;
        }
        case LUA_TTABLE:
        {
            // todo
        }
        default:
        {
            lua_pushnil(recv);
            break;
        }
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

static void waitonlist(lua_State *L, const char *channel, Proc **list)
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
        pthread_cond_wait(&p->cond, &kernel_access);
    } while (p->channel);
}

static int ll_send(lua_State *L)
{
    const char *channel = luaL_checkstring(L, 1);
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
        waitonlist(L, channel, &waittosend);
    }
    pthread_mutex_unlock(&kernel_access);
    return 0;
}

static int ll_recv(lua_State *L)
{
    const char *channel = luaL_checkstring(L, 1);
    lua_settop(L, 1);
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
        waitonlist(L, channel, &waittorecv);
    }
    pthread_mutex_unlock(&kernel_access);
    return lua_gettop(L) - 1;
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
