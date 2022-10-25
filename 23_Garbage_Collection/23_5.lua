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
