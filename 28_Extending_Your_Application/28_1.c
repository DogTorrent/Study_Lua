// 练习28.1：请编写一个C程序，该程序读取一个定义了函数f的Lua文件（函数以一个数值参数对一个数值结构的形式给出），
// 并绘制出该函数（无须你做任何特别的事情，程序会像16.1节中的例子一样用ASCII星号绘出结果）。

#pragma comment(lib, "../ThirdParty/lib/lua.lib")
#include <stdio.h>
#include <string.h>
#include "lua.h"
#include "lauxlib.h"
#include "lualib.h"

int main()
{
    lua_State *L = luaL_newstate();
    if (luaL_loadfile(L, "28_1_file.lua") || lua_pcall(L, 0, 0, 0))
        luaL_error(L, "cannot load file. file: %s", lua_tostring(L, -1));
    int i = 0;
    while (i < 20)
    {
        if (lua_getglobal(L, "f") != LUA_TFUNCTION)
            luaL_error(L, "cannot get function 'f'");
        lua_pushnumber(L, i);
        lua_pcall(L, 1, 1, 0);
        int isnum;
        int num = (int)lua_tointegerx(L, -1, &isnum);
        if (isnum)
        {
            printf("%d", num);
            for (int j = 0; j < num; j++)
            {
                printf("*");
            }
            printf("\n");
        }
        else
        {
            luaL_error(L, "wrong result type");
            break;
        }
        i = num;
    }
}
