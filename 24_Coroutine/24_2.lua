-- 练习24.2：练习6.5要求编写一个函数来输出指定数组元素的所有组合。请使用协程把该函数修改为组合的生成器。
-- 该生成器的用法如下：
-- for c in combinations({"a", "b", "c"}, 2) do
--     printResult(c)
-- end

local function combinations(tb, len)
    local function combination(result, i)
        if #result == len then
            return coroutine.yield(result)
        end
        if i > #tb then
            return
        end
        table.insert(result, tb[i])
        combination(result, i + 1)
        table.remove(result)
        combination(result, i + 1)
    end

    return coroutine.wrap(function()
        combination({}, 1)
    end)
end

local function printResult(a)
    for i = 1, #a do io.write(a[i], " ") end
    io.write("\n")
end

for c in combinations({ "a", "b", "c" }, 2) do
    printResult(c)
end
