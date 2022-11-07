local absolute_path_end = -string.find(string.reverse(arg[0]), "[/\\]")
local absolute_path = string.sub(arg[0], 1, absolute_path_end)
package.cpath = package.cpath .. ";?.dll;" .. absolute_path .. "?.dll"
local DirLib = require("dirlib")

for name in DirLib.open("E:\\Projects\\Study_Lua") do
    print(name)
end
