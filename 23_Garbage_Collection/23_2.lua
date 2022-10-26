-- 练习23.2：考虑23.6节的第一个例子，该示例创建了一个带有析构器的表，该析构器再执行时只是输出一条消息。
-- 如果程序没有进行过垃圾收集就退出会发生什么？如果程序调用了函数os.exit呢？如果程序由于出错而退出呢？

o = { x = "hi" }
setmetatable(o, { __gc = function(o) print(o.x) end })
o = nil

-- os.exit(0) -- no output
-- error("this is an error message") -- log error info and then print `hi`
print("This is end")
