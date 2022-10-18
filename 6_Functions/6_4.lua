-- 练习6.4：请编写一个函数，该函数用于打乱（shuffle）一个指定的数组。请保证所有的排列都是等概率的。

function shuffle_array(arr)
    math.randomseed(os.clock() * 1000)
    print(#arr)
    for i = 1, #arr do
        n = math.random(i, #arr)
        arr[i], arr[n] = arr[n], arr[i]
    end
end

arr = { 1, 2, 3, 4, 5, 6, 7, 8, 9, nil, 0 }
shuffle_array(arr)
print(table.unpack(arr))
