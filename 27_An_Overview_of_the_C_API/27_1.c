// 练习27.1：编译并运行简单的独立运行的解释器（示例27.1）。

#pragma comment(lib, "../ThirdParty/lib/lua.lib")
#include "lua.h"
#include "lauxlib.h"
#include "lualib.h"

int main()
{
    char buff[256];
    int error;
    lua_State *L = luaL_newstate();
    luaL_openlibs(L);

    while (fgets(buff, sizeof(buff), stdin) != NULL)
    {
        error = luaL_loadstring(L, buff) || lua_pcall(L, 0, 0, 0);
        if (error)
        {
            fprintf(stderr, "%s\n", lua_tostring(L, -1));
            lua_pop(L, 1);
        }
    }

    lua_close(L);
    return 0;
}

// cmd /k """path/to/vcvars64.bat"" x64 && cl.exe 27_1.c -I ../ThirdParty/include/ && del 27_1.obj && exit || exit"
// copy ..\lua.dll .\ && cmd /k "27_1.exe && exit || exit" && del lua.dll || del lua.dll
