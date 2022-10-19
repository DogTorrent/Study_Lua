-- 练习14.2：改写示例14.2中队列的实现，使得当队列为空时两个索引都返回0。

local queue = {
    listNew = function()
        return { first = 0, last = 0 }
    end,

    pushFirst = function(list, value)
        local first = list.first
        list[first] = value
        if list.last == first then list.last = first + 1 end
        list.first = first - 1
    end,

    pushLast = function(list, value)
        local last = list.last
        list[last] = value
        if list.first == last then list.first = last - 1 end
        list.last = last + 1
    end,

    popFirst = function(list)
        if list.first == list.last then return nil end
        local first = list.first + 1
        local value = list[first]
        list[first] = nil
        if first == list.last then
            list.first = 0
            list.last = 0
        else list.first = first end
        return value
    end,

    popLast = function(list)
        if list.first == list.last then return nil end
        local last = list.last - 1
        local value = list[last]
        list[last] = nil
        if last == list.first then
            list.first = 0
            list.last = 0
        else list.last = last end
        return value
    end,
}

local l = queue.listNew()
queue.pushFirst(l, 1)
queue.pushLast(l, 2)
print(queue.popFirst(l))
print(queue.popFirst(l))
print(queue.popFirst(l))
print(l.first, l.last)
