-- 练习33.2：修改lproc，使得这个库能够发送和接收其他诸如布尔值和数值的类型时无须将其转换成字符串（提示：只需要修改函数movevalues即可）。
-- 练习33.3：修改库lproc，使得这个库能够发送和接收表（提示：可以通过遍历原表在接收状态中创建一个副本）。
-- 练习33.4：在库lproc中实现无阻塞的send操作。

local file_folder_path_end = -string.find(string.reverse(arg[0]), "[/\\]")
local file_folder_path = string.sub(arg[0], 1, file_folder_path_end)
local project_folder_path = io.popen("cd"):read("l") .. "\\";
package.cpath = package.cpath
    .. ";" .. project_folder_path .. "?.dll"
    .. ";" .. file_folder_path .. "?.dll"
local lproc = require("lproclib")


lproc.start([[
    local lproc = require("lproclib");
    lproc.send("test_channel", 0, "test1", true, 999, { "aaa", "bbb", { ["ccc"] = true }, [{}] = 6 }, 10.5)
]])

os.execute("pwsh -Command \"sleep 0.1\"")

lproc.start([[
    local lproc = require("lproclib")

    local function printtable(t)
        io.write("{ ")
        for k, v in pairs(t) do
            if type(k) == "table" then
                io.write("[")
                printtable(k)
                io.write("] = ")
            elseif type(k) == "string" then
                io.write(string.format("[%q] = ", k))
            else
                io.write(string.format("[%s] = ", tostring(k)))
            end

            if type(v) == "table" then
                printtable(v)
            elseif type(v) == "string" then
                io.write(string.format("%q", v))
            else
                io.write(tostring(v))
            end
            io.write(", ")
        end
        io.write("}")
    end
    
    local function printout(...)
        local len = select("#", ...)
        for i = 1, len do
            local value = select(i, ...)
            if type(value) == "table" then
                printtable(value)
                io.write("\t")
            elseif type(value) == "string" then
                io.write(string.format("%q\t", value))
            else
                io.write(string.format("%s\t", tostring(value)))
            end
        end
    end
    
    printout(lproc.recv("test_channel", 1))
]])

lproc.start([[
    local lproc = require("lproclib");
    lproc.send("test_channel", 0, "test2", true, 999, { "aaa", "bbb", { ["ccc"] = true }, [{}] = 6 }, 10.5)
]])
