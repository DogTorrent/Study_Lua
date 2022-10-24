-- 练习20.1：请定义一个__sub元方法，该方法用于计算两个集合的差集（集合a-b是位于集合a但不位于集合b中的元素）

local relative_path_start = select(2, string.find(string.lower(arg[0]), string.lower(io.popen("cd"):read("l")))) + 1
local relative_path_end = -string.find(string.reverse(arg[0]), "[/\\]")
local relative_path = string.sub(arg[0], relative_path_start, relative_path_end)

local Set = require(relative_path .. "set")

local a = Set.new { 1, 2, 3, 4, 5 }
local b = Set.new { 4, 5, 6, 7, 8 }
local mt = getmetatable(a)

mt.__sub = function(a, b)
    local ans = Set.new {}
    for e in pairs(a) do
        ans[e] = (b[e] == nil) and true or nil
    end
    return ans
end

print(Set.toString(a - b))
