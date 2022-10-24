-- 练习18.4：请编写一个迭代器,该迭代器返回指定字符串的所有非空子串。

local function substrs(str)
    local size = 1
    local pos = 1 - size
    return function()
        pos = pos + 1
        if pos + size - 1 > #str then
            size = size + 1
            pos = 1
        end
        if size <= #str then
            return string.sub(str, pos, pos + size - 1)
        end
        return nil
    end
end

for str in substrs("abcdefg") do
    io.write(str, " ")
end
