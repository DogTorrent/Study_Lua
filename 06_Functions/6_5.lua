-- 练习6.5：请编写一个函数，其参数为一个数组，返回值为数组中元素的所有组合。
-- 提示：可以使用组合的递推公式 C(n, m) = C(n-1, m-1) + C(n-1, m)。
-- 要计算从n个元素中选出m个组成的组合C(n, m)，可以先将第一个元素加到结果集中，然后计算所有的其他元素的C(n-1, m-1)；
-- 然后，从结果集中删掉第一个元素，再计算其他所有剩余元素的 C(n-1, m)。
-- 当n小于m时，组合不存在；当m为0时，只有一种组合（一个元素也没有）。

function get_all_combine(arr, index, t)
    index = index or 1
    t = t or { {} }
    if index > #arr then return t end
    for i = 1, #t do
        table.insert(t, {})
        for j = 1, #t[i] do
            table.insert(t[#t], t[i][j])
        end
        table.insert(t[#t], arr[index])
    end
    return get_all_combine(arr, index + 1, t)
end

t = get_all_combine({ 1, 2, 3, 4, 5, 6 })
for i = 1, #t do
    print("case" .. tostring(i), table.unpack(t[i]))
end
