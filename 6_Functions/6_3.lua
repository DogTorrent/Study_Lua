-- 练习6.3：请编写一个函数，该函数的参数为可变数量的一组值，返回值为除最后一个元素之外的其他所有值。

function get_vars_except_last(...)
    t = table.pack(...)
    table.remove(t)
    return table.unpack(t)
end

print(get_vars_except_last(9, 8, 7, 6, 5, 4, nil, 2, 1))
