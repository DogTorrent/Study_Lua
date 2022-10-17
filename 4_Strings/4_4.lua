-- 练习4.4：使用UTF-8字符串重写下例：
-- > insert("ação", 5, "!") --> ação!
-- 注意，这里的起始位置和长度都是针对代码点(CodePoint)而言的

function insert(dest, pos, str)
    break_point = utf8.offset(dest, pos)
    return string.format("%s%s%s", string.sub(dest, 1, break_point - 1), str, string.sub(dest, break_point, #dest))
end

os.execute("chcp 65001")
print(insert("ação", 5, "!"))

