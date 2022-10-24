-- 练习21.3：使用对偶表示重新实现类Stack。
local Stack = {}

do
    local stack_internal = {}

    function Stack:new(initialStack)
        local o = {}
        setmetatable(o, self)
        self.__index = self
        stack_internal[o] = initialStack or {}
        return o
    end

    function Stack:push(value)
        table.insert(stack_internal[self], value)
    end

    function Stack:pop()
        return table.remove(stack_internal[self])
    end

    function Stack:top()
        return stack_internal[self][#stack_internal[self]]
    end

    function Stack:isempty()
        return #stack_internal[self] == 0
    end
end

local stack = Stack:new { 1, 2, 3 }
print(stack:isempty())
stack:push(4)
print(stack:top())
print(stack:pop())
print(stack:pop())
print(stack:pop())
print(stack:isempty())
print(stack:pop())
print(stack:isempty())
