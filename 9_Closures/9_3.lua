-- 练习9.3：练习5.4要求我们编写一个以多项式（使用表表示）和值x为参数、返回结果为对应多项式值的函数。
-- 请编写该函数的柯里化（curried）版本，该版本的函数应该以一个多项式为参数并返回另一个函数（当这个函数的入参是值x时返回对应多项式的值）。
-- 考虑如下的示例：
-- f = newpoly({3, 0, 1})
-- print(f(0))     --3
-- print(f(5))     --28
-- print(f(10))    --103

-- 注：部分内容copy自练习5.5而非练习5.4

local function newpoly(t)
    return function(x)
        sum = 0;
        for i = #t, 1, -1 do
            sum = sum * x + t[i]
        end
        return sum
    end
end

f = newpoly({ 3, 0, 1 })
print(f(0))
print(f(5))
print(f(10))
