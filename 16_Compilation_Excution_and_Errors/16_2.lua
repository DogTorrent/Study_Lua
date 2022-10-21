-- 练习16.2：请编写一个函数multiload ，该函数接收一组字符串或函数来生成函数loadwithprefix ，如下例所示：
-- f = multiload("local x = 10;",
--                io.lines("temp", "*L"),
--                " print(x)")
-- 在上例中，函数multiload应该加载一段等价于字符串"local..." 、temp文件的内容和字符串"print(x)"连接在一起后的代码。
-- 与上一练习中的函数loadwithprefix类似，函数multiload也不应该进行任何实际的字符串连接操作。

local function multiload(...)
    local paras = table.pack(...)
    local curr_index = 1
    return load(function()
        ::restart::
        if type(paras[curr_index]) == "function" then
            local str = paras[curr_index]()
            if str == nil then
                curr_index = curr_index + 1
                goto restart
            else
                return str
            end
        else
            local last_index = curr_index
            curr_index = curr_index + 1
            return paras[last_index]
        end
    end)
end

f = multiload("local x = 10;",
               io.lines(string.sub(arg[0], 1, -string.find(string.reverse(arg[0]), "[/\\]")) .. "16_2_temp", "*L"),
               " print(x)")()
