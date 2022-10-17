-- 练习5.4：在Lua语言中，我们可以使用由系数组成的列表{a0, a1, ..., an}来表达多项式a_n * x ^ n + a_n-1 * x ^ (n - 1) + ... + a_1 * x ^ 1 + a0
-- 请编写一个函数，该函数以多项式（使用表表示）和值x为参数，返回结果为对应多项式的值。

function get_sum(t, x)
    sum = 0;
    for index, value in ipairs(t) do
        sum = sum + value * x ^ (index - 1)
    end
    return sum
end

print(get_sum({ 1, 2, 3 }, 2)) -- 1 + 2 * 2 ^ 1 + 3 * 2 ^ 2 = 17
