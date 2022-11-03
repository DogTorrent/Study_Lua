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
