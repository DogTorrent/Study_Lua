-- 练习4.7：请编写一个函数判断指定的字符串是否为回文字符串（palindrome）：
-- > ispali("step on no pets") --> true
-- > ispali("banana") --> false

function ispali(str)
    for i = 1, #str // 2 do
        if string.byte(str, i) ~= string.byte(str, -i) then return false end
    end
    return true
end

print(ispali("step on no pets"))
print(ispali("banana"))
