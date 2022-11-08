-- 练习4.3：请编写一个函数，使之实现在某个字符串的指定位置插入另一个字符串：
-- > insert("hello world", 1, "start: ") --> start: hello world
-- > insert("hello world", 7, "small ") --> hello small world

function insert(dest, pos, str)
    return string.format("%s%s%s", string.sub(dest, 1, pos - 1), str, string.sub(dest, pos, #dest))
end

print(insert("Hello world", 1, "start: "))
print(insert("Hello world", 7, "small "))
