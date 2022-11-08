-- 练习5.7：请编写一个函数，该函数将指定列表的所有元素插入到别一个列表的指定位置

function insertList(destination, source, pos)
    source_size = #source
    for i = #destination, pos, -1 do
        destination[i + source_size] = destination[i]
    end
    for i = 1, source_size do
        destination[pos + i - 1] = source[i]
    end
end

l1 = { 1, 2, 3, 4, 5 }
l2 = { 10, 20, 30, 40, 50 }
insertList(l1, l2, 3)
print(table.unpack(l1))
