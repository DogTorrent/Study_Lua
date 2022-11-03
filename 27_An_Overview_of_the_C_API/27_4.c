// 练习7.4：请编写一个库，该库允许一个脚本限制其Lua状态能够使用的总内存大小。该库可能仅提供一个函数setlimit，用来设置限制值。
// 这个库应该设置它自己的内存分配函数，此函数在调用原始的分配函数之前，应该检查在使用的内存总量，并且在请求的内存超出限制时返回NULL。
// （提示：这个库可以使用分配函数的用户数据来保存状态，例如字节数、当前内存限制等；请记住，在调用原始分配函数时应该使用原始的用户数据。）

#pragma comment(lib, "../ThirdParty/lib/lua.lib")
#include <stdlib.h>
#include "lua.h"
#include "lauxlib.h"
#include "lualib.h"

struct limit_info_ud
{
    size_t max;
    size_t cur;
    lua_Alloc old_alloc_f;
    void *old_ud;
};

void *new_lua_alloc_func(void *ud, void *ptr, size_t osize, size_t nsize)
{
    struct limit_info_ud *info_ud = (struct limit_info_ud *)ud;
    long long delta = nsize - (ptr == NULL ? (size_t)0 : osize);

    printf("total is %zd, try allocate %zd, previous is %zd\n", info_ud->cur, nsize, ptr == NULL ? 0 : osize);

    if (delta > 0 && info_ud->cur + delta > info_ud->max)
        return NULL;
    info_ud->cur += delta;

    return (*(info_ud->old_alloc_f))(info_ud->old_ud, ptr, osize, nsize);
}

void set_state_limit(lua_State *L, size_t msize)
{
    void *old_ud = NULL;
    lua_Alloc old_alloc_f = lua_getallocf(L, &old_ud);
    if (*old_alloc_f == new_lua_alloc_func)
    {
        ((struct limit_info_ud *)old_ud)->max = msize;
    }
    else
    {
        struct limit_info_ud *new_ud = (struct limit_info_ud *)malloc(sizeof(struct limit_info_ud));
        new_ud->max = msize;
        new_ud->cur = lua_gc(L, LUA_GCCOUNT) * 1024 + lua_gc(L, LUA_GCCOUNTB);
        new_ud->old_alloc_f = old_alloc_f;
        new_ud->old_ud = old_ud;
        lua_setallocf(L, &new_lua_alloc_func, (void *)new_ud);
    }
}

void test(size_t size)
{
    lua_State *L = luaL_newstate();
    set_state_limit(L, size);
    luaL_openlibs(L);
    lua_close(L);
    printf("[pass] limit %zd bytes\n", size);
    return;
}

int main()
{
    test(1024 * 20);
    // test(1024); // PANIC: unprotected error in call to Lua API (not enough memory)
}

// cmd /k """path/to/vcvars64.bat"" x64 && cl.exe 27_4.c -I ../ThirdParty/include/ && del 27_4.obj && exit || exit"
// copy ..\lua.dll .\ && cmd /k "27_4.exe && exit || exit" && del lua.dll || del lua.dll