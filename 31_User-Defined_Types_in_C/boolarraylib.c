#pragma comment(lib, "../ThirdParty/lib/lua.lib")
#include <limits.h>
#include "lua.h"
#include "lualib.h"
#include "lauxlib.h"

#define BITS_PER_WORLD (CHAR_BIT * sizeof(unsigned int))
#define I_WORLD(i) ((unsigned int)(i) / BITS_PER_WORLD)
#define I_BIT(i) (1 << ((unsigned int)(i) % BITS_PER_WORLD))
#define checkarray(L, arg) (BitArray *)luaL_checkudata(L, arg, "boolarraylib")

typedef struct BitArray
{
    int size;
    unsigned int values[1];
} BitArray;

static int newarray(lua_State *L)
{
    int n = (int)luaL_checkinteger(L, 1);

    luaL_argcheck(L, n >= 1, 1, "invalid size");

    size_t nbytes = sizeof(BitArray) + I_WORLD(n - 1) * sizeof(unsigned int);
    BitArray *a = (BitArray *)lua_newuserdata(L, nbytes);

    a->size = n;
    for (size_t i = 0; i <= I_WORLD(n - 1); ++i)
    {
        a->values[i] = 0;
    }
    luaL_getmetatable(L, "boolarraylib");
    lua_setmetatable(L, -2);

    return 1;
}

/// @brief 获取栈中参数， 第一个参数为BitArray对象（userdata）的指针/地址, 第二个参数为要访问的位数（按照Lua标准从1开始）
/// @param L
/// @param mask 用于访问指定比特位的掩码（由该函数返回）
/// @return 指定比特位所在区域（BitArray的values数组中的一项）的指针/地址
static unsigned int *getparams(lua_State *L, unsigned int *mask)
{
    BitArray *a = checkarray(L, 1);
    int index = (int)luaL_checkinteger(L, 2) - 1;

    luaL_argcheck(L, index >= 0 && index < a->size, 2, "index out of range");

    *mask = I_BIT(index);
    return &a->values[I_WORLD(index)];
}

static int setarray(lua_State *L)
{
    unsigned int mask;
    unsigned int *entry = getparams(L, &mask);

    luaL_checktype(L, 3, LUA_TBOOLEAN);

    if (lua_toboolean(L, 3))
        *entry |= mask;
    else
        *entry &= ~mask;
    return 0;
}

static int getarray(lua_State *L)
{
    unsigned int mask;
    unsigned int *entry = getparams(L, &mask);

    lua_pushboolean(L, *entry & mask);
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
        if (a->values[I_WORLD(i)] & I_BIT(i))
            luaL_addstring(&B, "true");
        else
            luaL_addstring(&B, "false");
        if (i + 1 < a->size)
            luaL_addstring(&B, ", ");
    }
    luaL_addstring(&B, " ]");
    luaL_pushresult(&B);
    return 1;
}

static int calcunion(lua_State *L)
{
    BitArray *a = checkarray(L, 1);
    BitArray *b = checkarray(L, 2);
    lua_settop(L, 0);
    int new_size = a->size > b->size ? a->size : b->size;
    lua_pushinteger(L, new_size);
    newarray(L);
    BitArray *result = checkarray(L, -1);
    for (size_t i = 0; i <= I_WORLD(new_size - 1); i++)
    {
        unsigned int va = i > I_WORLD(a->size - 1) ? 0 : a->values[i];
        unsigned int vb = i > I_WORLD(b->size - 1) ? 0 : b->values[i];
        result->values[i] = va | vb;
    }
    return 1;
}

static int calcintersection(lua_State *L)
{
    BitArray *a = checkarray(L, 1);
    BitArray *b = checkarray(L, 2);
    lua_settop(L, 0);
    int new_size = a->size > b->size ? a->size : b->size;
    lua_pushinteger(L, new_size);
    newarray(L);
    BitArray *result = checkarray(L, -1);
    for (size_t i = 0; i <= I_WORLD(new_size - 1); i++)
    {
        unsigned int va = i > I_WORLD(a->size - 1) ? 0 : a->values[i];
        unsigned int vb = i > I_WORLD(b->size - 1) ? 0 : b->values[i];
        result->values[i] = va & vb;
    }
    return 1;
}

__declspec(dllexport) int luaopen_boolarraylib(lua_State *L)
{
    static const struct luaL_Reg lib_funcs[] = {
        {"new", newarray},
        {NULL, NULL}};
    static const struct luaL_Reg obj_funcs[] = {
        {"__index", getarray},
        {"__newindex", setarray},
        {"__len", getsize},
        {"__tostring", array2string},
        {"__add", calcunion},
        {"__mul", calcintersection},
        {NULL, NULL}};

    luaL_newmetatable(L, "boolarraylib");
    luaL_setfuncs(L, obj_funcs, 0);

    luaL_newlib(L, lib_funcs);
    return 1;
}

// cmd /k """path/to/vcvars64.bat"" x64 && cl.exe boolarraylib.c -I ../ThirdParty/include/ -link -DLL -OUT:boolarraylib.dll && del boolarraylib.obj boolarraylib.lib boolarraylib.exp && exit || exit"
