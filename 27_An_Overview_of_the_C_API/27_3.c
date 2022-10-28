// 练习7.2：假设栈是空的，执行下列代码后，栈中会是什么内容？
// lua_pushnumber(L, 3.5);
// lua_pushstring(L, "hello");
// lua_pushnil(L);
// lua_rotate(L, 1, -1);
// lua_pushvalue(L, -2);
// lua_remove(L, 1);
// lua_insert(L, -2);
// 练习7.3：使用函数stackDump（见示例27.2）检查上一道题的答案。

#include <stdio.h>
#include <string.h>
#include "lua.h"
#include "lauxlib.h"
#include "lualib.h"

static void stackDump(lua_State *L);

int main()
{
    lua_State *L = luaL_newstate();

    luaL_openlibs(L);

    lua_pushnumber(L, 3.5);
    stackDump(L); // 3.5

    lua_pushstring(L, "hello");
    stackDump(L); // 3.5 'hello'

    lua_pushnil(L);
    stackDump(L); // 3.5 'hello' nil

    lua_rotate(L, 1, -1);
    stackDump(L); // 'hello' nil 3.5

    lua_pushvalue(L, -2);
    stackDump(L); // 'hello' nil 3.5 nil

    lua_remove(L, 1);
    stackDump(L); // nil 3.5 nil

    lua_remove(L, -2);
    stackDump(L); // nil nil

    lua_close(L);
    return 0;
}

static void stackDump(lua_State *L)
{
    int i;
    int top = lua_gettop(L);
    for (i = 1; i <= top; i++)
    {
        int t = lua_type(L, i);
        switch (t)
        {
        case LUA_TSTRING:
        {
            printf("'%s'", lua_tostring(L, i));
            break;
        }
        case LUA_TBOOLEAN:
        {
            printf(lua_toboolean(L, i) ? "true" : "false");
            break;
        }
        case LUA_TNUMBER:
        {
            printf("%g", lua_tonumber(L, i));
            break;
        }

        default:
        {
            printf("%s", lua_typename(L, t));
            break;
        }
        }
        printf(" ");
    }
    printf("\n");
}