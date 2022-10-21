-- 练习17.3 如果库搜索路径中包含固定的路径组成（即没有包含问号）会发生什么？这一行为有用吗？

local absolute_path_end = -string.find(string.reverse(arg[0]), "[/\\]")
local absolute_path = string.sub(arg[0], 1, absolute_path_end)

package.path = package.path .. ";" .. absolute_path .. "queue.lua"

local queue1 = require("not a valid module name")
print(type(queue1)) -- table
local q = queue1.listNew()
queue1.pushFirst(q, 10)
print(queue1.popFirst(q)) -- 10

queue1.temp = 1
print(queue1.temp) -- 1

local queue2 = require("not a valid module name")
print(queue2.temp) -- 1 (same as queue1)

local queue3 = require("not a valid module name, and different from previous module name")
print(queue3.temp) -- nil
