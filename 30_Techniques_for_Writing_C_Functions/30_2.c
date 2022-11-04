// 练习30.2：修改函数split（见示例30.2），使其可以处理包含\0的字符串（可以用memchr替代strchr）。

#pragma comment(lib, "../ThirdParty/lib/lua.lib")
#include "lua.h"
#include "lualib.h"
#include "lauxlib.h"
#include "string.h"

static int l_split(lua_State *L)
{
    const char *s = luaL_checkstring(L, 1);
    size_t s_len = luaL_len(L, 1);
    const char *s_end = s + s_len;
    const char *sep = luaL_checkstring(L, 2);
    const char *e;
    int i = 1;

    lua_newtable(L);
    while ((e = memchr(s, *sep, s_len)) != NULL)
    {
        lua_pushlstring(L, s, e - s);
        lua_rawseti(L, -2, i++);
        s = e + 1;
    }
    lua_pushlstring(L, s, s_end - s);
    lua_rawseti(L, -2, i);

    return 1;
}

int main()
{
    lua_State *L = luaL_newstate();
    luaL_openlibs(L);
    lua_register(L, "split", l_split);
    int error = luaL_dostring(L, "print(table.unpack(split('a;b\\0cd;e\\0fg', ';')))");
    if (error)
    {
        fprintf(stderr, "%s\n", lua_tostring(L, -1));
        lua_pop(L, -1);
    }
    lua_close(L);
}

// cmd /k """path/to/vcvars64.bat"" x64 && cl.exe 30_2.c -I ../ThirdParty/include/ && del 30_2.obj && exit || exit"
// copy ..\lua.dll .\ && cmd /k "30_2.exe && exit || exit" && del lua.dll || del lua.dll
