-- 练习29.1：请使用C语言编写一个可变长参数函数summation，来计算数值类型参数的和：
--   print(summation())                 --> 0
--   print(summation(2.3, 5.4))         --> 7.7
--   print(summation(2.3, 5.4, -34))    --> -26.3 
--   print(summation(2.3, 5.4, {}))
--     --> stdin:1: bad gument #3 to 'summation'
--                  (number expected, got table) 
-- 练习29.2：请实现一个与标准库中的table.pack等价的函数
-- 练习29.3：请编写一个函数，该函数接收任意个参数，然后逆序将其返回
--   print(reverse(1, "hello", 20))     --> 20  hello 
-- 练习29.4：请编写一个函数foreach，该函数的参数为一张表和一个函数，然后对表中的每个键值对调用传入的函数。
--   foreach({x = 10, y= 20}, print) 
--     -->  x   10 
--     -->  y   20
-- (提示：在Lua语言手册中查一下函数lua_next。)
-- 练习29.5：请重写练习29.4中的函数foreach，让它所调用的函数支持yield。
-- 练习29.6：用前面所有练习中的函数创建一个C语言模块。

local absolute_path_end = -string.find(string.reverse(arg[0]), "[/\\]")
local absolute_path = string.sub(arg[0], 1, absolute_path_end)
package.cpath = package.cpath .. ";?.dll;" .. absolute_path .. "?.dll"
local mylib = require("mylib")

print(mylib.summation())
print(mylib.summation(1.5, 2, 3.2, 10))

print(table.unpack(mylib.pack("aaa", 10, 1, nil, 0)))

print(mylib.reverse(1, "hello", 20))

mylib.foreach({ 1, 2, 3, 4, 5, "a" }, print);

local co = coroutine.create(function()
    mylib.foreachk({ 1, 2, 3, 4, 5, "a" }, function(k, v)
        print(k, v)
        coroutine.yield(k)
        print(k, v)
    end);
end)

local _, k = coroutine.resume(co)
while k ~= nil do
    _, k = coroutine.resume(co)
end
