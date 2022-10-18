-- 练习9.1：请一个函数integral，该函数以一个函数f为参数并返回其积分的近似值。

local function integral(f, from, to)
    local sum = 0
    local delta = (to - from) / 100
    for i = from + delta / 2, to - delta / 2, delta do
        sum = sum + f(i) * delta
    end
    return sum
end

print(integral(function(x) return 5 * x + 1 end, 0, 5))
