-- 练习18.3：请编写一个迭代器uniquewords,该迭代器返回指定文件中没有重复的所有单词。
-- （提示:基于示例中allwords的代码，使用一个表来存储已经处理过的所有单词）

local function uniquewords()
    local line = io.read()
    local pos = 1
    local words = {}
    return function()
        while line do
            local w, e = string.match(line, "(%w+)()", pos)
            if w then
                pos = e
                if words[w] == nil then
                    words[w] = true
                    return w
                end
            else
                line = io.read()
                pos = 1
            end
        end
        return nil
    end
end

for word in uniquewords() do
    io.write(word, " ")
end
