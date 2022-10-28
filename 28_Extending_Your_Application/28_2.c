// 练习28.2：修改函数call_va（见示例28.5）来处理布尔类型的值。

#include <stdarg.h>
#include <stdio.h>
#include <string.h>
#include "lua.h"
#include "lauxlib.h"
#include "lualib.h"

void call_va(lua_State *L, const char *func, const char *sig, ...)
{
    va_list vl;
    int narg, nres;
    va_start(vl, sig);
    lua_getglobal(L, func);

    for (narg = 0; *sig; narg++)
    {
        luaL_checkstack(L, 1, "too many arguments");
        switch (*sig++)
        {
        case 'd':
            lua_pushnumber(L, va_arg(vl, double));
            break;

        case 'i':
            lua_pushinteger(L, va_arg(vl, int));
            break;

        case 's':
            lua_pushstring(L, va_arg(vl, char *));

        case 'b':
            lua_pushboolean(L, va_arg(vl, int));
            break;

        case '>':
            goto endargs;
            break;

        default:
            luaL_error(L, "invalid option (%c)", *(sig - 1));
        }
    }
endargs:

    nres = (int)strlen(sig);
    if (lua_pcall(L, narg, nres, 0) != 0)
        luaL_error(L, "error calling '%s'", lua_tostring(L, -1));

    nres = -nres;
    while (*sig)
    {
        switch (*sig++)
        {
        case 'd':
        {
            int isnum;
            double n = lua_tonumberx(L, nres, &isnum);
            if (!isnum)
                luaL_error(L, "wrong result type");
            *va_arg(vl, double *) = n;
            break;
        }

        case 'i':
        {
            int isnum;
            int n = (int)lua_tointegerx(L, nres, &isnum);
            if (!isnum)
                luaL_error(L, "wrong result type");
            *va_arg(vl, int *) = n;
            break;
        }

        case 's':
        {
            const char *s = lua_tostring(L, nres);
            if (s == NULL)
                luaL_error(L, "wrong result type");
            *va_arg(vl, const char **) = s;
            break;
        }

        case 'b':
        {
            int b = lua_toboolean(L, nres);
            *va_arg(vl, int *) = b;
            break;
        }

        default:
            luaL_error(L, "invalid option (%c)", *(sig - 1));
        }
        nres++;
    }

    va_end(vl);
}

int main()
{
    lua_State *L = luaL_newstate();
    if (luaL_loadstring(L, "f = function(b) return not b end") || lua_pcall(L, 0, 0, 0))
        luaL_error(L, "load string error");
    int b;
    call_va(L, "f", "b>b", 0, &b);
    printf("%s", b ? "true" : "false");
}
