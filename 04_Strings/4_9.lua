-- 练习4.9：使用UTF-8字符串重写之前的练习

function ispali(str)
    l = 1
    r = utf8.len(str)
    pattern = "[%p%s]" -- %p匹配标点符号 %s匹配空白符号
    while l < r do
        while l < r and string.sub(str, utf8.offset(str, l), utf8.offset(str, l + 1) - 1):match(pattern) do l = l + 1 end
        while l < r and string.sub(str, utf8.offset(str, r), utf8.offset(str, r + 1) - 1):match(pattern) do r = r - 1 end
        if utf8.codepoint(str, utf8.offset(str, l)) ~= utf8.codepoint(str, utf8.offset(str, r)) then return false end
        l = l + 1
        r = r - 1
    end
    return true
end

print(ispali("啊哦,on ,.no 哦啊"))
print(ispali("呃呃呃诶"))
