-- 练习18.1：请编写一个迭代器fromto，使得如下循环与数值型for等价
-- for i in fromto(n, m) do
--     body
-- end
-- 你能否以无状态迭代器实现？

local fromto = function(n, m)
    local i = n - 1
    return function() i = i + 1; return (i <= m) and i or nil end
end

for i in fromto(5, 10) do
    print(i)
end

local ns_fromto = function(n, m)
    return function(max, cur) cur = cur + 1; return cur <= max and cur or nil end, m, n - 1
end

for i in ns_fromto(5, 10) do
    print(i)
end
