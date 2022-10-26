-- 练习23.5：对于这个练习，你需要至少一个使用很多内存的Lua脚本。如果你没有这样的脚本，那就写一个（一个创建表的循环就可以）。
-- ● 使用不同的palse和stepmul运行脚本。它们的值是如何影响脚本的性能和内存使用的？
--   如果把pause值设为0会发生什么？如果把pause设成1000会发生什么？
--   如果把stepmul设成0会发生什么？如果把stepmul设成1000000会发生什么？
-- ● 调整你的脚本，使其能够完整地控制垃圾收集器。脚本应该让垃圾收集器停止运行，然后时不时地完成垃圾收集的工作。你能够使用这种方式提高脚本的性能吗？

local function test(pause, stepmul)
    collectgarbage("setpause", pause)
    collectgarbage("setstepmul", stepmul)
    collectgarbage()
    local memory = 0
    local time = os.clock()
    do
        local t = {}
        for i = 1, 100000000 do
            t[i] = {}
        end
        memory = collectgarbage("count")
    end
    time = os.clock() - time
    print("pause = " .. pause, "stepmul = " .. stepmul, "time = " .. time, "memory = " .. memory * 1024)
end

test(1000, 0)
test(1000, 1000000)
test(0, 0)
test(0, 1000000)
-- output:
-- pause = 1000    stepmul = 0          time = 9.94      memory = 7747506374.0
-- pause = 1000    stepmul = 1000000    time = 10.268    memory = 7747506374.0
-- pause = 0       stepmul = 0          time = 27.832    memory = 7747506374.0
-- pause = 0       stepmul = 1000000    time = 6.923     memory = 7747506374.0
