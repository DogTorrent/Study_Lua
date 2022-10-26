-- 练习23.4：解释示例23.3中程序的输出。

local count = 0

local mt = { __gc = function() count = count - 1 end }
local a = {}

for i = 1, 1000 do
    count = count + 1
    a[i] = setmetatable({}, mt)
end

collectgarbage()
print(collectgarbage("count") * 1024, count) -- 94693.0 1000    回收其他，未回收a中元素的内存情况
a = nil
collectgarbage()
print(collectgarbage("count") * 1024, count) -- 78317.0 0       第一次回收后的内存情况，原a中元素有__gc，所以未被回收全部内存而是被析构（因为析构参数是自身，需被复活）
collectgarbage()
print(collectgarbage("count") * 1024, count) -- 22317.0 0       第二次回收后的内存情况，原a中元素（此时被标记为已析构，因此不会被重复析构）被回收内存

-- output:
-- 94693.0 1000
-- 78317.0 0
-- 22317.0 0
