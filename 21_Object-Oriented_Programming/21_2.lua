-- 练习21.1：实现一个类Stack，该类具有方法push、pop、top和isempty。
-- 练习21.2：实现类Stack的子类StackQueue。除了继承的方法外，还给这个子类增加一个方法insertbottom，该方法在栈的底部插入一个元素（这个方法使得我们可以把这个类的实例用作队列）。

local Stack = {}

function Stack:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function Stack:push(value)
    table.insert(self, value)
end

function Stack:pop()
    return table.remove(self)
end

function Stack:top()
    return self[#self]
end

function Stack:isempty()
    return #self == 0
end

local StackQueue = Stack:new()

function StackQueue:insertbottom(value)
    table.insert(self, 1, value)
end

local stack = StackQueue:new { 1, 2, 3 }
print(stack:isempty())
stack:insertbottom(0)
stack:push(4)
print(stack:top())
print(stack:pop())
print(stack:pop())
print(stack:pop())
print(stack:pop())
print(stack:isempty())
print(stack:pop())
print(stack:isempty())
