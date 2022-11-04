// 练习30.l：用C语言实现一个过滤函数（filter function），该函数接收一个列表和一个判定条件，
// 然后返回指定列表中满足该判定条件的所有元素组成的新列表。
//   t = filter({1, 3, 20, -4, 5}, function(x) return x < 5 end)
//   -- t = {1, 3, -4}
// 判定条件就是一个函数，该函数测试一些条件并返回一个布尔值。

#pragma comment(lib, "../ThirdParty/lib/lua.lib")
#include "lua.h"
#include "lualib.h"
#include "lauxlib.h"

static int l_filter(lua_State *L)
{
    luaL_checktype(L, 1, LUA_TTABLE);
    luaL_checktype(L, 2, LUA_TFUNCTION);
    lua_newtable(L);
    int new_table_size = 0;
    for (size_t i = 1; i <= luaL_len(L, 1); i++)
    {
        lua_pushvalue(L, 2); // f
        lua_geti(L, 1, i);   // arg
        lua_call(L, 1, 1);
        if (lua_toboolean(L, -1))
        {
            lua_geti(L, 1, i);
            lua_rawseti(L, 3, ++new_table_size);
        }
        lua_pop(L, 1);
    }
    return 1;
}

int main()
{
    lua_State *L = luaL_newstate();
    luaL_openlibs(L);
    lua_register(L, "filter", l_filter);
    int error = luaL_dostring(L, "print(table.unpack(filter({1, 3, 20, -4, 5}, function(x) return x < 5 end)))");
    if (error)
    {
        fprintf(stderr, "%s\n", lua_tostring(L, -1));
        lua_pop(L, -1);
    }
    lua_close(L);
}

// cmd /k """path/to/vcvars64.bat"" x64 && cl.exe 30_1.c -I ../ThirdParty/include/ && del 30_1.obj && exit || exit"
// copy ..\lua.dll .\ && cmd /k "30_1.exe && exit || exit" && del lua.dll || del lua.dll
