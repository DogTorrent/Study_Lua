-- 练习17.4 编写一个同时搜索Lua文件和C标准库的搜索器。
-- (提示:使用函数package.searchpath寻找正确的文件，然后试着依次使用函数loadfile和函数package.loadlib加载该文件)

local function search_lua_and_c(name)
    local fname = package.searchpath(name, package.path)
    if fname ~= nil then
        return loadfile(fname)
    end
    fname = package.searchpath(name, package.cpath)
    if fname ~= nil then
        return package.loadlib(name)
    end
    return nil
end
