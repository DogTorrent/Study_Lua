#pragma comment(lib, "../ThirdParty/lib/lua.lib")
#include "lua.h"
#include "lualib.h"
#include "lauxlib.h"
#include "string.h"

static char lib_reg_key = 'k';
static int l_settrans(lua_State *L)
{
    luaL_checktype(L, 1, LUA_TTABLE);
    lua_rawsetp(L, LUA_REGISTRYINDEX, (void *)&lib_reg_key);
    return 0;
}

static int l_gettrans(lua_State *L)
{
    lua_rawgetp(L, LUA_REGISTRYINDEX, (void *)&lib_reg_key);
    return 1;
}

static int l_transliterate(lua_State *L)
{
    const char *s = luaL_checkstring(L, 1);
    size_t s_len = luaL_len(L, 1);

    int t_type = lua_rawgetp(L, LUA_REGISTRYINDEX, (void *)&lib_reg_key);
    if (t_type != LUA_TTABLE)
    {
        lua_pop(L, 1);
        lua_newtable(L);
        lua_pushvalue(L, 2);
        lua_rawsetp(L, LUA_REGISTRYINDEX, (void *)&lib_reg_key);
    }

    luaL_Buffer str_buff;
    char *buff_p = luaL_buffinitsize(L, &str_buff, s_len);
    size_t buff_len = 0;
    for (size_t i = 0; i < s_len; i++)
    {
        char key[2] = {s[i], '\0'};
        int r_type = lua_getfield(L, 2, key);
        if (r_type == LUA_TSTRING)
        {
            buff_p[buff_len++] = *lua_tolstring(L, -1, NULL);
        }
        else if (r_type != LUA_TBOOLEAN || lua_toboolean(L, -1) != 0)
        {
            buff_p[buff_len++] = s[i];
        }
        lua_pop(L, 1);
    }
    lua_pop(L, 1);
    luaL_pushresultsize(&str_buff, buff_len);
    return 1;
}

__declspec(dllexport) int luaopen_translib(lua_State *L)
{
    static const struct luaL_Reg libTable[] = {
        {"settrans", l_settrans},
        {"gettrans", l_gettrans},
        {"transliterate", l_transliterate},
        {NULL, NULL}};
    luaL_newlib(L, libTable);
    return 1;
}

// cmd /k """path/to/vcvars64.bat"" x64 && cl.exe translib-30_4.c -I ../ThirdParty/include/ -link -DLL -OUT:translib-30_4.dll && del translib-30_4.obj translib-30_4.lib translib-30_4.exp && exit || exit"
