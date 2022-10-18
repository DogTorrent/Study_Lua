-- 练习6.6：有时，具有正确尾调用（proper-tail call）的语句被称为正确的尾递归（properly tail recursive），
-- 争论在于这种正确性只与递归调用有关（如果没有递归调用，那么一个程序的最大调用深度是静态固定的）。
-- 请证明上述争论的观点在像Lua语言一样的动态语言中不成立：不使用递归，编写一个能够实现支持无限调用链（unbounded call chain）的程序（提示：参考6.1节）。

-- 注：翻译有误，应为16.1节

-- 尾递归
function tail_recursive(x)
    if x > 0 then return tail_recursive(x - 1) end
end

-- 递归
function recursive(x)
    if x > 0 then return 0 + recursive(x - 1) end
end

-- 非递归？题意不明

-- recursive(10000000)
tail_recursive(10000000)
