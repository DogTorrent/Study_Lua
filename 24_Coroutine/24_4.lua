-- 练习24.4：请为基于协程的库（示例24.5）编写一个行迭代器，以便于使用for循环来读取一个文件

local relative_path_start = select(2, string.find(string.lower(arg[0]), string.lower(io.popen("cd"):read("l")))) + 1
local relative_path_end = -string.find(string.reverse(arg[0]), "[/\\]")
local relative_path = string.sub(arg[0], relative_path_start, relative_path_end)

local lib = require(relative_path .. "async-lib")


local memorize_t = setmetatable({}, { __mode = "v" })

local function run(code)
    local co = coroutine.wrap(function()
        code()
        lib.stop()
    end)
    co()
    lib.runloop()
end

local function putline(stream, line)
    local co = coroutine.running()
    local callback = memorize_t["putline_callback@" .. tostring(co)]
    if callback == nil then
        callback = function()
            coroutine.resume(co)
        end
        memorize_t["putline_callback@" .. tostring(co)] = callback
    end
    lib.writeline(stream, line, callback)
    coroutine.yield()
end

local function getline(stream)
    local co = coroutine.running()
    local callback = memorize_t["getline_callback@" .. tostring(co)]
    if callback == nil then
        callback = function(l)
            coroutine.resume(co, l)
        end
        memorize_t["getline_callback@" .. tostring(co)] = callback
    end
    lib.readline(stream, callback)
    return coroutine.yield()
end

-- 方式1：读一行返回一行，需要协程嵌套，由loop协程驱动创建读取事件的协程，loop在事件回调内将行yield回main，然后再resume创建读取事件的协程
-- 其实只是在回调中多加一行coroutine.yield(l)，在resume回创建事件协程前先将行返回到主线程，也就是：main <-> loop <-> read
do
    local function file_line_itr(filename)
        local stream = io.open(string.sub(arg[0], 1, relative_path_end) .. filename)
        local create_read_event = coroutine.wrap(function()
            while true do
                local co = coroutine.running()
                local callback = memorize_t["getline_callback@" .. tostring(co)]
                if callback == nil then
                    callback = function(l)
                        -- 只在不为nil时yeild，如果直接返回nil，for不会再次调用迭代器，也就导致不执行stop任务
                        -- （虽然这里没有影响，但是如果stop内有一些收尾工作的话就会出问题）
                        if l then coroutine.yield(l) end
                        coroutine.resume(co, l)
                    end
                    memorize_t["getline_callback@" .. tostring(co)] = callback
                end
                lib.readline(stream, callback)
                if coroutine.yield() == nil then break end
            end
            lib.stop()
            stream:close()
        end)
        return coroutine.wrap(function()
            create_read_event()
            lib.runloop()
        end)
    end

    for line in file_line_itr("24_4_file") do
        io.write(line, "\n")
    end
end

-- 方式2：读一行返回一行，需要协程嵌套，由创建读取事件的协程驱动loop协程，loop在事件回调内yield回创建读取事件的协程
-- 也就是：main <-> read <-> loop
do
    local function file_line_itr(filename)
        local stream = io.open(string.sub(arg[0], 1, relative_path_end) .. filename)
        local loop_co = coroutine.create(function() lib.runloop() end)
        return coroutine.wrap(function()
            while true do
                local co = coroutine.running()
                local callback = memorize_t["getline_callback@" .. tostring(co)]
                if callback == nil then
                    callback = function(l)
                        coroutine.yield(l)
                    end
                    memorize_t["getline_callback@" .. tostring(co)] = callback
                end
                lib.readline(stream, callback)
                local _, line = coroutine.resume(loop_co)
                if line == nil then break end
                coroutine.yield(line)
            end
            lib.stop()
            coroutine.resume(loop_co)
        end)
    end

    for line in file_line_itr("24_4_file") do
        io.write(line, "\n")
    end
end

-- 方式3：读全部然后分行返回
do
    local function file_line_itr(filename)
        local stream = io.open(string.sub(arg[0], 1, relative_path_end) .. filename)
        local t = {}
        run(function()
            while true do
                local line = getline(stream)
                if not line then break end
                t[#t + 1] = line
            end
        end)
        local i = 0
        return function()
            i = i + 1
            return t[i]
        end
    end

    for line in file_line_itr("24_4_file") do
        io.write(line, "\n")
    end
end
