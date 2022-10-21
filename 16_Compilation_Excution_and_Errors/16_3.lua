-- 练习16.3：示例16.2中的函数stringrep使用二进制乘法算法（binary multiplication algorithn）来完成将指定字符串s的n个副本连接在一起的需求：
-- 示倒16.2 字符串复制
-- function stringrep(s, n)
--     local r = ""
--     if n > 0 then
--         while n > 1 do
--             if n % 2 ~= 0 then r = r .. s end
--             s = s .. s
--             n = math.floor(n / 2)
--         end
--         r = r .. s
--     end
--     return r
-- end
-- 对于任意固定的n 我们可以通过将循环展开为一系列的r=r .. s 和s=s .. s语句来创建一个特殊版本的stringrep。
-- 例如，在n=5时可以展开为如下的函数：
-- function stringrep_5(s)
--     local r = ""
--     r = r .. s
--     s = s .. s
--     s = s .. s
--     r = r .. s
--     return r
-- end
-- 请编写一个函数， 该函数对于指定的n返回特定版本的函数stringrep_n 。在实现方面， 不能使用闭包，而是应该构造出包含合理指令序列（r = r .. s 和s = s .. s 的组合）的Lua代码，
-- 然后再使用函数load生成最终的函数。请比较通用版本的stringrep函数（或者使用该函数的闭包）与我们自己实现的版本之间的性能差异。

local function get_stringrep_n(n)
    local is_first_call = true
    local is_last_call = false
    return load(function()
        local ret
        if is_first_call then
            is_first_call = false
            ret = "return (function(s)\nlocal r = \"\"\n"
        elseif is_last_call then
            ret = nil
        else
            local cn = n
            n = math.floor(n / 2)
            if cn == 0 then
                is_last_call = true
                ret = "return r\nend)\n"
            elseif cn == 1 then ret = "r = r .. s\n"
            elseif cn > 1 then
                ret = (cn % 2 == 0) and "" or "r = r .. s\n"
                ret = ret .. "s = s .. s\n"
            end
        end
        return ret
    end)()
end

function stringrep(s, n)
    local r = ""
    if n > 0 then
        while n > 1 do
            if n % 2 ~= 0 then r = r .. s end
            s = s .. s
            n = math.floor(n / 2)
        end
        r = r .. s
    end
    return r
end

stringrep_5 = get_stringrep_n(100000000)
t = os.clock()
stringrep_5("abc")
print((os.clock() - t)) -- 0.141

t = os.clock()
stringrep("abc", 100000000)
print((os.clock() - t)) -- 0.156
