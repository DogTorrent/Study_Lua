-- 练习23.3 假设要实现一个记忆表，该记忆表所针对函数的参数和返回值都是字符串。由于弱引用表不把字符串当作可回收对象，
-- 因此将这个记忆表标记为弱引用并不能使得其中的键值对能够被垃圾收集。在这种情况下，你该如何实现记忆呢？

-- 用table包裹即可，只是每次gc都会回收全部（因为没有外部的强引用）
do
    local memorized_result = setmetatable({}, { __mode = "v" })
    function addline(str)
        local result = memorized_result[str]
        if result == nil then
            result = { s = "_" .. str }
            memorized_result[str] = result
            print("create result string:", result.s)
        else
            print("reuse result string:", result.s)
        end
        return result.s
    end

    addline("test")
    addline("test")
    collectgarbage()
    addline("test")
end
