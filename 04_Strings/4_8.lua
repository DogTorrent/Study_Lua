-- 练习4.8：重写之前的练习，使得它们忽略空格和标点符号。

function ispali(str)
    l = 1
    r = #str
    pattern = "[%p%s]" -- %p匹配标点符号 %s匹配空白符号
    while l < r do
        while l < r and string.sub(str, l, l):match(pattern) do l = l + 1 end
        while l < r and string.sub(str, r, r):match(pattern) do r = r - 1 end
        if string.byte(str, l) ~= string.byte(str, r) then return false end
        l = l + 1
        r = r - 1
    end
    return true
end

print(ispali("step on no pets"))
print(ispali("banana"))
