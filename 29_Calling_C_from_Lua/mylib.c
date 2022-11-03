#pragma comment(lib, "../ThirdParty/lib/lua.lib")
#include "lua.h"
#include "lauxlib.h"
#include "lualib.h"

static int l_summation(lua_State *L)
{
    unsigned narg = lua_gettop(L);
    double res = 0;
    for (unsigned i = 1; i <= narg; i++)
    {
        double p = luaL_checknumber(L, i);
        res += p;
    }
    lua_pushnumber(L, res);
    return 1;
}

static int l_pack(lua_State *L)
{
    unsigned narg = lua_gettop(L);
    lua_createtable(L, narg, 0);
    for (unsigned i = 1; i <= narg; i++)
    {
        lua_pushinteger(L, i);
        lua_pushvalue(L, i);
        lua_settable(L, -3);
    }
    return 1;
}

static int l_reverse(lua_State *L)
{
    unsigned narg = lua_gettop(L);
    for (unsigned i = narg; i >= 1; i--)
    {
        lua_pushvalue(L, i);
    }
    return narg;
}

static int l_foreach(lua_State *L)
{
    luaL_checktype(L, 1, LUA_TTABLE);
    luaL_checktype(L, 2, LUA_TFUNCTION);
    // see https://www.lua.org/manual/5.4/manual.html#lua_next
    lua_pushnil(L); // first key
    while (lua_next(L, 1) != 0)
    {
        // push one more key before function
        lua_pushvalue(L, 3);
        lua_insert(L, 3);
        // push function
        lua_pushvalue(L, 2);
        lua_insert(L, 4);
        int stat_code = lua_pcall(L, 2, 0, 0);
        if (stat_code != LUA_OK)
        {
            return lua_error(L);
        }
    }
    lua_settop(L, 2);
    return 0;
}

static int foreach_continuation(lua_State *L, int status, intptr_t ctx)
{
    if (status == LUA_YIELD || status == LUA_OK)
    {
        // see https://www.lua.org/manual/5.4/manual.html#lua_next
        if (lua_gettop(L) == 2)
            lua_pushnil(L); // first key
        while (lua_next(L, 1) != 0)
        {
            // push one more key before function
            lua_pushvalue(L, 3);
            lua_insert(L, 3);
            // push function
            lua_pushvalue(L, 2);
            lua_insert(L, 4);
            lua_pcallk(L, 2, 0, 0, 0, foreach_continuation);
        }
    }
    lua_settop(L, 2);
    return 0;
}

static int l_foreach_yieldable(lua_State *L)
{
    luaL_checktype(L, 1, LUA_TTABLE);
    luaL_checktype(L, 2, LUA_TFUNCTION);
    foreach_continuation(L, LUA_OK, 0);
    return 0;
}

__declspec(dllexport) int luaopen_mylib(lua_State *L)
{
    static const struct luaL_Reg libTable[] = {
        {"summation", l_summation},
        {"pack", l_pack},
        {"reverse", l_reverse},
        {"foreach", l_foreach},
        {"foreachk", l_foreach_yieldable},
        {NULL, NULL}};
    luaL_newlib(L, libTable);
    return 1;
}

// cmd /k """path/to/vcvars64.bat"" x64 && cl.exe mylib.c -I ../ThirdParty/include/ -link -DLL -OUT:mylib.dll && del mylib.obj mylib.lib mylib.exp && exit || exit"
// or: gcc -I ..\ThirdParty\include\ .\mylib.c -c -fPIC -shared -o mylib.dll