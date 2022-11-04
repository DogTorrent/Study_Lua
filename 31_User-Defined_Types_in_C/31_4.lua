-- 练习31.1：修改setarray的实现，让它只能接受布尔值
-- 练习31.2：我们可以将一个布尔数组看作是一个整型的集合（在数组中值为true的索引）。在布尔数组的实现中增加计算两个数组间并集和交集的函数，这两个函数接收两个布尔数组并返回一个新数组且不修改其参数。
-- 练习31.3：在上一个练习的基础上扩展，让我们可以用加法来获取两个数组的并集，用乘法来获取两个数组的交集。
-- 练习31.4：修改元方法__tostring的实现，让它可以用一种恰当的方式显示数组的所有内容。请使用字符串缓冲机制（见30.2节）创建结果字符串。

local absolute_path_end = -string.find(string.reverse(arg[0]), "[/\\]")
local absolute_path = string.sub(arg[0], 1, absolute_path_end)
package.cpath = package.cpath .. ";?.dll;" .. absolute_path .. "?.dll"
local BoolArray = require("boolarraylib")

local arr1 = BoolArray.new(5);
arr1[4] = true
arr1[5] = true
-- arr1[5] = 1 -- bad argument #3 to 'newindex' (boolean expected, got number)
print("arr1[1]: ", arr1[1])
print("arr1: ", arr1);

local arr2 = BoolArray.new(6);
arr2[5] = true
print("arr2: ", arr2);
print("arr1 + arr2: ", arr1 + arr2)
print("arr1 * arr2: ", arr1 * arr2)
