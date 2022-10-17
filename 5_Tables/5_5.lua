-- 练习5.5：改写上述函数，使之最多使用n个加法和n个乘法（且没有指数）

function get_sum(t, x)
    sum = 0;
    for i = #t, 1, -1 do
        sum = sum * x + t[i]
    end
    return sum
end

print(get_sum({ 1, 2, 3 }, 2)) -- 1 + 2 * 2 ^ 1 + 3 * 2 ^ 2 = 17
