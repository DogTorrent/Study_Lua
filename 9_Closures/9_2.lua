-- 练习9.2：请问如下的代码段将输出怎样的结果：

function F(x)
    return {
        set = function(y) x = y end,
        get = function() return x end
    }
end

o1 = F(10)
o2 = F(20)
print(o1.get(), o2.get())

o2.set(100)
o1.set(300)
print(o1.get(), o2.get())
