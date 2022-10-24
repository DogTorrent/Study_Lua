-- 练习20.4：代理表可以表示除表外的其 类型的对象。请编写一个函数fileAsArray，该函数以一个文件名为参数，返回值为对应文件的代理，
-- 当执行t=fileAsArray("myFile")后，访问t[i]返回指定文件的第i个字节，而对t[i]的赋值更新第i个字节。
-- 练习20.5：扩展之前的示例，使得我们能够使用pairs(t)遍历一个文件中的所有字节，并使用#t来获得文件的大小。

local mt = {
    __index = function(proxy, pos)
        proxy.f:seek("set", pos - 1)
        return proxy.f:read(1)
    end,

    __newindex = function(proxy, pos, value)
        assert(#value == 1)
        proxy.f:seek("set", pos - 1)
        proxy.f:write(value)
    end,

    __len = function(proxy)
        return proxy.f:seek("end")
    end,

    __pairs = function(proxy)
        return function(proxy, key)
            key = key + 1
            local value = proxy[key]
            return value ~= nil and key or nil, value
        end, proxy, 0
    end
}

local function fileAsArray(filename)
    local proxy = {}
    proxy.f = io.open(filename, "r+")
    setmetatable(proxy, mt)
    return (proxy.f ~= nil) and proxy or nil
end

local path = string.sub(arg[0], 1, -string.find(string.reverse(arg[0]), "[/\\]"))
local fileArray = fileAsArray(path .. "20_5_file")

fileArray[5] = "!"
print(fileArray[5])

fileArray[5] = "5"
print(fileArray[5])

print(#fileArray)

for i, v in pairs(fileArray) do
    io.write(v)
end
