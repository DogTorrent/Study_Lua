-- 练习5.8：表标准库中提供了函数table.concat，该函数将指定表的字符串元素连接在一起：
-- print(table.concat({"hello", " ", "world"})) --> hello world
-- 请实现该函数，并比较在大数据量（具有上百万个元素的表，可利用for循环生成）情况下与标准库之间的性能差异。

function concat(t)
    stack = {}
    for i = 1, #t do
        s = t[i]
        for size = #stack, 1, -1 do
            if #stack[size] >= #s then break end
            s = table.remove(stack) .. s
        end
        table.insert(stack, s)
    end

    ans = ""
    for _ = 1, #stack do
        ans = table.remove(stack) .. ans
    end
    return ans
end

long_t = {}
for i = 1, 1000000 do
    long_t[i] = ("1234567890"):sub(1, math.random(10))
end

time = os.clock()
ans = concat(long_t)
print(os.clock() - time) -- 0.362

time = os.clock()
ans = table.concat(long_t)
print(os.clock() - time) -- 0.022
