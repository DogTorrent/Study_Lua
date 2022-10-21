-- 练习16.4：你能否想到一个使pcall(pcall, f)的第1个返回值为false的f？为什么这样的f会有存在的意义呢？

-- see https://stackoverflow.com/questions/39113323/how-do-i-find-an-f-that-makes-pcallpcall-f-return-false-in-lua

local f = (function() end)()
b1 = pcall(pcall, (function() end)())
print(b1) -- false
b2 = pcall(pcall, f)
print(b2) -- true
