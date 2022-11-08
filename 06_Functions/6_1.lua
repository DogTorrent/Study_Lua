-- 练习6.1：请编写一个函数，该函数的参数为一个数组，打印出该数组的所有元素。

function print_array(arr)
    print(table.unpack(arr))
end

print_array { 9, 8, 7, 6, 5, 4, nil, 2, 1 }
