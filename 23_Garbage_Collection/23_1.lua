-- 练习23.1：编写一个实验证明为什么Lua语言需要实现瞬表（记得调用函数collectgarbage来强制进行一次垃圾收集）。
-- 如果可能的话，分别在Lua5.1和Lua5.2/5.3中运行你的代码来看看有什么不同。

do
    local mt = {
        __gc = function()
            print("[ephemeron test] finalize")
        end
    }
    local ephemeron_t = setmetatable({}, { __mode = "k" })
    do
        local t = setmetatable({}, mt)
        ephemeron_t[t] = t
    end
    collectgarbage()
    print("[ephemeron test] end")
end
-- output:
-- [ephemeron test] finalize
-- [ephemeron test] end
-- key为weak而value为strong的table才是瞬表，上面代码块中的ephemeron_t就是瞬表，所以collectgarbage()可以回收表中无引用的元素
-- key为weak，虽然value理论上应该强引用key对应的table，但是因为没有其他对该table的强引用，瞬表特性使得value也是对该table的弱引用，最终导致该table被标记为非活跃而被回收

do
    local mt = {
        __gc = function()
            print("[not ephemeron test] finalize")
        end
    }
    local not_ephemeron_t = setmetatable({}, { __mode = "v" })
    do
        local t = setmetatable({}, mt)
        not_ephemeron_t[t] = t
    end
    collectgarbage()
    print("[not ephemeron test] end")
end
-- output:
-- [not ephemeron test] end
-- [not ephemeron test] finalize
-- key为strong而value为weak的table不是瞬表，上面代码块中的not_ephemeron_t不是瞬表，所以collectgarbage()无法回收表中无引用的元素
-- 虽然value为weak，但是因为key强引用了value对应的table，所以该table被标记为活跃而不被回收
