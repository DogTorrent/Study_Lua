// 练习30.3：用C语言重新实现函数transliterate（练习10.3）。

#pragma comment(lib, "../ThirdParty/lib/lua.lib")
#include "lua.h"
#include "lualib.h"
#include "lauxlib.h"
#include "string.h"

static int l_transliterate(lua_State *L)
{
    const char *s = luaL_checkstring(L, 1);
    luaL_checktype(L, 2, LUA_TTABLE);
    size_t s_len = luaL_len(L, 1);
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
    luaL_pushresultsize(&str_buff, buff_len);
    return 1;
}

int main()
{
    lua_State *L = luaL_newstate();
    luaL_openlibs(L);
    lua_register(L, "transliterate", l_transliterate);
    int error = luaL_dostring(L, "print(transliterate('abcdefg', { a = 'z', b = 'y', c = false }))");
    if (error)
    {
        fprintf(stderr, "%s\n", lua_tostring(L, -1));
        lua_pop(L, -1);
    }
    lua_close(L);
}

// cmd /k """path/to/vcvars64.bat"" x64 && cl.exe 30_3.c -I ../ThirdParty/include/ && del 30_3.obj && exit || exit"
// copy ..\lua.dll .\ && cmd /k "30_3.exe && exit || exit" && del lua.dll || del lua.dll
