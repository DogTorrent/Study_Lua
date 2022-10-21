-- 练习17.2： 将几何区域系统的实现（9.4节）重写为恰当的模块

local relative_path_start = select(2, string.find(string.lower(arg[0]), string.lower(io.popen("cd"):read("l")))) + 1
local relative_path_end = -string.find(string.reverse(arg[0]), "[/\\]")
local relative_path = string.sub(arg[0], relative_path_start, relative_path_end)

local geometry = require(relative_path .. "geometry")
