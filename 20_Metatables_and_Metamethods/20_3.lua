-- 练习20.3：实现只读表的另一种方式是将一个函数用作__index元方法。这种方式使得访问的开销更大，但是创建只读表的开销更小。（因为所有的只读表能够共享一个元表）
-- 请使用这种方式重写函数readOnly

local mt = {
    __index = function(proxy, k)
        return proxy.t[k]
    end,
    __newindex = function(proxy, k, v)
        error("attempt to update a read-only table", 2)
    end
}

local function readOnly(t)
    local proxy = { t = t }
    setmetatable(proxy, mt)
    return proxy
end

local days = readOnly { "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday" }

print(days[1])
days[2] = "Noday"

