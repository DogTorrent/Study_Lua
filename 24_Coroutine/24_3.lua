-- 练习24.3：在示例24.5中，函数getline和putline每一次调用都会产生一个新的闭包。请使用记忆技术来避免这种资源浪费。

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

run(function()
    local t = {}
    local inp = io.input()
    local out = io.output()

    while true do
        local line = getline(inp)
        if not line then break end
        t[#t + 1] = line
    end

    for i = #t, 1, -1 do
        putline(out, t[i] .. "\n")
    end
end)
