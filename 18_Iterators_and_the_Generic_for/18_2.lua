-- 练习18.2：向上一个练习中的地带器增加一个步进的参数。你能否也用无状态迭代器实现？

local fromto = function(n, m, step)
    step = step or 1
    local i = n - step
    return function() i = i + step; return (i <= m) and i or nil end
end

for i in fromto(5, 10, 2) do
    print(i)
end

local ns_fromto = function(n, m, step)
    step = step or 1
    return function(max, cur) cur = cur + step; return cur <= max and cur or nil end, m, n - step
end

for i in ns_fromto(5, 10, 2) do
    print(i)
end
