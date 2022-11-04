-- 练习30.4：通过修改transliterate实现一个库，让翻译表不是作为参数给出，而是直接由库给出。这个库应该提供如下的函数：
--   lib.settrans (table ) －－ 设直翻译表
--   lib.gettrans() －－ 获取翻译表
--   lib.transliterate(s） --根据当前的表翻译's'
-- 使用注册表来保存翻译表。

local absolute_path_end = -string.find(string.reverse(arg[0]), "[/\\]")
local absolute_path = string.sub(arg[0], 1, absolute_path_end)
package.cpath = package.cpath .. ";?.dll;" .. absolute_path .. "?.dll"
local translib = require("translib-30_4")

translib.settrans({ a = 'z', b = 'y', c = false })

local t = translib.gettrans()
for key, value in pairs(t) do
    print(key, value)
end

print(translib.transliterate('abcdefg'))
