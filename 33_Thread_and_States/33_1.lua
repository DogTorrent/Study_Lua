local file_folder_path_end = -string.find(string.reverse(arg[0]), "[/\\]")
local file_folder_path = string.sub(arg[0], 1, file_folder_path_end)
local project_folder_path = io.popen("cd"):read("l") .. "\\";
package.cpath = package.cpath
    .. ";" .. project_folder_path .. "?.dll"
    .. ";" .. file_folder_path .. "?.dll"
local lproc = require("lproclib")

lproc.start([[
    local lproc = require("lproclib");
    print(lproc.recv("test_channel"))
]])

lproc.start([[
    local lproc = require("lproclib");
    lproc.send("test_channel", "test", true, 999)
]])
