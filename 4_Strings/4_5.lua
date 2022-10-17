-- 练习4.5：请编写一个函数，该函数用于移除指定字符串中的一部分，移除的部分使用起始位置和长度指定：
-- > remove("hello world", 7, 4) --> hello d

function remove(str, start, len)
    return string.sub(str, 1, start - 1) .. string.sub(str, start + len, #str)
end

print(remove("hello world", 7, 4))
