-- 练习17.1： 将双端队列的实现（示例14.2）重写为恰当的模块

local relative_path_start = select(2, string.find(string.lower(arg[0]), string.lower(io.popen("cd"):read("l")))) + 1
local relative_path_end = -string.find(string.reverse(arg[0]), "[/\\]")
local relative_path = string.sub(arg[0], relative_path_start, relative_path_end)

local queue = require(relative_path .. "queue")
