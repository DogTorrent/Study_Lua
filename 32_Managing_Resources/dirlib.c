#pragma comment(lib, "../ThirdParty/lib/lua.lib")
#include <dirent.h>
#include <errno.h>
#include <string.h>
#include "lua.h"
#include "lauxlib.h"

static int dir_iter(lua_State *L);

static int l_dir(lua_State *L)
{
    const char *path = luaL_checkstring(L, 1);
    DIR **d = (DIR **)lua_newuserdata(L, sizeof(DIR *));
    *d = NULL;

    luaL_getmetatable(L, "dirlib");
    lua_setmetatable(L, -2);
    *d = opendir(path);
    if (*d == NULL)
        luaL_error(L, "cannot open %s: %s", path, strerror(errno));
    lua_pushcclosure(L, dir_iter, 1);
    return 1;
}

static int dir_iter(lua_State *L)
{
    DIR *d = *(DIR **)lua_touserdata(L, lua_upvalueindex(1));
    if (d == NULL)
        return 0;
    struct dirent *entry = readdir(d);
    if (entry == NULL)
    {
        closedir(d);
        d = NULL;
        return 0;
    }
    lua_pushstring(L, entry->d_name);
    return 1;
}

static int dir_gc(lua_State *L)
{
    DIR *d = *(DIR **)lua_touserdata(L, 1);
    if (d != NULL)
    {
        closedir(d);
        d = NULL;
    }
    return 0;
}

__declspec(dllexport) int luaopen_dirlib(lua_State *L)
{
    static const struct luaL_Reg lib_funcs[] = {
        {"open", l_dir},
        {NULL, NULL}};
    luaL_newmetatable(L, "dirlib");
    lua_pushcfunction(L, dir_gc);
    lua_setfield(L, -2, "__gc");

    luaL_newlib(L, lib_funcs);
    return 1;
}

// cmd /k """path/to/vcvars64.bat"" x64 && cl.exe dirlib.c -I ../ThirdParty/include/ -link -DLL -OUT:dirlib.dll && del dirlib.obj dirlib.lib dirlib.exp && exit || exit"
