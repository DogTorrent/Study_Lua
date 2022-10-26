-- 练习24.6：请在Lua语言中实现一个transfer函数。如果读者觉得认为唤醒-挂起（resume， yeld）和调用-返回（call-return）类似，
-- 那么transfer就类似goto：它挂起运行中的协程，然后唤醒其他被当作参数给出的协程
-- （提示：使用某种调度机制来控制协程。之后，transfer会把执行权让给调度器以通知下一个协程运行，而调度器就则唤醒下一个协程）。

local dispatcher = {
    co_to_run = {}
}

function dispatcher:run()
    while #self.co_to_run > 0 do
        coroutine.resume(table.remove(self.co_to_run))
    end
end

function dispatcher:transfer(target_co)
    table.insert(self.co_to_run, target_co)
    coroutine.yield()
end

local co1, co2
co1 = coroutine.create(function()
    while true do
        print(tostring(coroutine.running()))
        dispatcher:transfer(co2)
    end
end)
co2 = coroutine.create(function()
    while true do
        print(tostring(coroutine.running()))
        dispatcher:transfer(co1)
    end
end)

table.insert(dispatcher.co_to_run, co1)
dispatcher:run()
