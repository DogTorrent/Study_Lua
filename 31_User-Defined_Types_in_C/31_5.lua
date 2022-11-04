-- 练习31.5：基于布尔数组的例子，为整数数组实现一个小型的C语言库。

local absolute_path_end = -string.find(string.reverse(arg[0]), "[/\\]")
local absolute_path = string.sub(arg[0], 1, absolute_path_end)
package.cpath = package.cpath .. ";?.dll;" .. absolute_path .. "?.dll"
local IntArray = require("intarraylib")

local arr1 = IntArray.new(5);
arr1[4] = 1
arr1[5] = 2
-- arr1[5] = true -- bad argument #3 to 'newindex' (number expected, got boolean)
-- arr1[6] = 10 -- bad argument #2 to 'newindex' (index out of range)
print("arr1[1]: ", arr1[1])
print("arr1: ", arr1);
