-- 练习30.5：使用上值保存翻译表并重新实现练习30.4。

local absolute_path_end = -string.find(string.reverse(arg[0]), "[/\\]")
local absolute_path = string.sub(arg[0], 1, absolute_path_end)
package.cpath = package.cpath .. ";?.dll;" .. absolute_path .. "?.dll"
local translib = require("translib-30_5")

translib.settrans({ a = 'z', b = 'y', c = false })

local t = translib.gettrans()
for key, value in pairs(t) do
    print(key, value)
end

print(translib.transliterate('abcdefg'))
