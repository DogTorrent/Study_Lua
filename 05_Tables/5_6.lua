-- 练习5.6：请编写一个函数，该函数用于测试制定的表是否为有效的序列。
-- P.S. 所有元素都不为nil的数组称为序列
function checkSequence(t)
    index = 0
    for key, value in pairs(t) do
        index = index + 1
        if key ~= index then return false end
    end
    return #t == index
end

print(checkSequence { 9, 8, 7, 6, 5 })
print(checkSequence { 9, nil, 8, 7, 6, 5 })
print(checkSequence { nil, 9, 8, 7, 6, 5 })
print(checkSequence { a = 0, 9, 8, 7, 6, 5 })
