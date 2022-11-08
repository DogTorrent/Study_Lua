-- 练习32.1：修改示例32.2中的函数dir_iter，使其在结束遍历时关闭DIR结构体。这样修改后，由于程序知道不再需要DIR，所以无须等待垃圾收集器来释放资源。
-- （当关闭目录时，应该把保存在用户数据中的地址设为NULL，以通知析构器该目录已经关闭。此外，dir_iter在使用目录前也必须检查目录是否已经关闭。）

local absolute_path_end = -string.find(string.reverse(arg[0]), "[/\\]")
local absolute_path = string.sub(arg[0], 1, absolute_path_end)
package.cpath = package.cpath .. ";?.dll;" .. absolute_path .. "?.dll"
local DirLib = require("dirlib")

for name in DirLib.open("E:\\Projects\\Study_Lua") do
    print(name)
end
