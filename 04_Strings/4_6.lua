-- 练习4.6：请使用UTF-8字符串重写下例：
-- > remove("ação", 2, 2) --> ao
-- 注意，起始位置和长度都是以代码点来表示的

function remove(str, start, len)
    return string.sub(str, 1, utf8.offset(str, start) - 1) .. string.sub(str, utf8.offset(str, start + len), #str)
end

os.execute("chcp 65001")
print(remove("ação", 2, 2))
