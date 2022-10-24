-- 练习21.4：对偶表示的一种变形是使用代理表示对象（20.4.4节）。每一个对象由一个空的代理表表示，一个内部的表把代理映射到保存对象状态的表。
-- 这个内部表不能从外部访问，但是方法可以使用内部表来把self变量转换为要操作的真正的表。
-- 请使用这种方式实现银行账户的示例，然后讨论这种方式的优点和缺点。

local Account = {}

do
    local proxy_to_obj = {}
    local proxy_mt = {
        __index = function(self, key)
            local f = proxy_to_obj[self][key]
            return type(f) == "function" and f or nil
        end
    }

    function Account:new(initialStack)
        initialStack = initialStack or {}
        initialStack.balance = initialStack.balance or 0
        setmetatable(initialStack, self)
        self.__index = self

        local proxy = {}
        proxy_to_obj[proxy] = initialStack
        setmetatable(proxy, proxy_mt)
        return proxy
    end

    function Account:withdraw(v)
        self = proxy_to_obj[self]
        self.balance = self.balance - v
    end

    function Account:deposit(v)
        self = proxy_to_obj[self]
        self.balance = self.balance + v
    end

    function Account:getBalance()
        self = proxy_to_obj[self]
        return self.balance
    end
end

local account = Account:new()
account:deposit(1000)
account:withdraw(500)
print(account:getBalance())
