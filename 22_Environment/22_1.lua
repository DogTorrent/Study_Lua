-- 练习22.1：本章开始时定义的函数getfield，由于可以接收像math?sun或string!!!gsub这样的“字段”而不够严谨。
-- 请将其重写，使得该函数只能支持点作为名称分隔符。

function getfield(f)
    local v = _G
    for word, split in string.gmatch(f, "([%a_][%w_]*)([^%a_]*)") do
        if split == "." or split == "" then
            v = v[word]
        else
            error("Invalid field string!")
        end
    end
    return v
end

print(getfield("math.sin"))
-- print(getfield("math?sin"))
-- print(getfield("math..sin"))
