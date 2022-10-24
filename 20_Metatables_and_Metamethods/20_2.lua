-- 练习20.2：请定义一个元方法__len，该元方法用于实现使用#s计算集合s中的元素个数

local relative_path_start = select(2, string.find(string.lower(arg[0]), string.lower(io.popen("cd"):read("l")))) + 1
local relative_path_end = -string.find(string.reverse(arg[0]), "[/\\]")
local relative_path = string.sub(arg[0], relative_path_start, relative_path_end)

local Set = require(relative_path .. "set")

local a = Set.new { 1, 2, 3, 4, 5 }
local b = Set.new { 4, 5, 6, 7, 8 }
local mt = getmetatable(a)

mt.__len = function(s)
    local len = 0
    for e in pairs(s) do
        len = (e == nil) and len or (len + 1)
    end
    return len
end

print(#b)
