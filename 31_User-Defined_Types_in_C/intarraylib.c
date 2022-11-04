#pragma comment(lib, "../ThirdParty/lib/lua.lib")
#include "lua.h"
#include "lualib.h"
#include "lauxlib.h"

#define checkarray(L, arg) (BitArray *)luaL_checkudata(L, arg, "intarraylib")

typedef struct BitArray
{
    int size;
    int values[1];
} BitArray;

static int newarray(lua_State *L)
{
    int n = (int)luaL_checkinteger(L, 1);

    luaL_argcheck(L, n >= 1, 1, "invalid size");

    size_t nbytes = sizeof(BitArray) + (n - 1) * sizeof(int);
    BitArray *a = (BitArray *)lua_newuserdata(L, nbytes);

    a->size = n;
    for (size_t i = 0; i <= n - 1; ++i)
    {
        a->values[i] = 0;
    }
    luaL_getmetatable(L, "intarraylib");
    lua_setmetatable(L, -2);

    return 1;
}

static int *getparams(lua_State *L)
{
    BitArray *a = checkarray(L, 1);
    int index = (int)luaL_checkinteger(L, 2) - 1;
    luaL_argcheck(L, index >= 0 && index < a->size, 2, "index out of range");

    return &a->values[index];
}

static int setarray(lua_State *L)
{
    int *entry = getparams(L);
    int value = (int)luaL_checkinteger(L, 3);

    *entry = value;
    return 0;
}

static int getarray(lua_State *L)
{
    int *entry = getparams(L);

    lua_pushinteger(L, *entry);
    return 1;
}

static int getsize(lua_State *L)
{
    BitArray *a = checkarray(L, 1);

    lua_pushinteger(L, a->size);
    return 1;
}

static int array2string(lua_State *L)
{
    BitArray *a = checkarray(L, 1);
    luaL_Buffer B;
    luaL_buffinit(L, &B);
    luaL_addstring(&B, "[ ");
    for (size_t i = 0; i < a->size; i++)
    {
        lua_pushinteger(L, a->values[i]);
        luaL_addvalue(&B);
        if (i + 1 < a->size)
            luaL_addstring(&B, ", ");
    }
    luaL_addstring(&B, " ]");
    luaL_pushresult(&B);
    return 1;
}

__declspec(dllexport) int luaopen_intarraylib(lua_State *L)
{
    static const struct luaL_Reg lib_funcs[] = {
        {"new", newarray},
        {NULL, NULL}};
    static const struct luaL_Reg obj_funcs[] = {
        {"__index", getarray},
        {"__newindex", setarray},
        {"__len", getsize},
        {"__tostring", array2string},
        {NULL, NULL}};

    luaL_newmetatable(L, "intarraylib");
    luaL_setfuncs(L, obj_funcs, 0);

    luaL_newlib(L, lib_funcs);
    return 1;
}

// cmd /k """path/to/vcvars64.bat"" x64 && cl.exe intarraylib.c -I ../ThirdParty/include/ -link -DLL -OUT:intarraylib.dll && del intarraylib.obj intarraylib.lib intarraylib.exp && exit || exit"
