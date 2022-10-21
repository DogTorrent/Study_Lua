-- 练习15.1：修改15.2中的代码，使其带缩进地输出嵌套表（提示：给函数serialize增加一个额外的参数来处理缩进字符串）。
-- 练习15.2：修改前面练习中的代码，使其像15.2.1节中的推荐的那样使用形如["key"] = value的语法。
-- 练习15.3：修改前面练习中的代码，使其只在必要时（即当键为字符串而不是合法标识符时）才使用形如["key"] = value的语法。
-- 练习15.4：修改前面练习中的代码，使其在可能时使用列表的构造器语法。
-- 例如，应将表{14, 15, 19}序列化为{14, 15, 19}而不是{[1] = 14, [2] = 15, [3] = 19}
-- （提示：只要键不是nil就从1,2,...开始保存对应键的值。请注意，在遍历其余表的时候不要再次保存它们）。

local function serialize(o, level)
    level = level or 0
    local t = type(o)
    local indentation = string.rep("\t", level)
    if t == "number" or t == "string" or t == "boolean" or t == "nil" then
        io.write(string.format("%q", o))
    elseif t == "table" then
        io.write("{\n")
        local number_key_index = 1
        for key, value in pairs(o) do
            local kt = type(key)
            io.write(indentation, "\t")
            if kt == "string" or kt == "boolean" or kt == "nil" then io.write(string.format("[%q] = ", key))
            elseif kt == "number" then
                if key ~= number_key_index then io.write(string.format("[%q] = ", key))
                else number_key_index = number_key_index + 1 end
            else error("cannot serialize a " .. t .. " key") end
            serialize(value, level + 1)
            io.write(",\n")
        end
        io.write(indentation .. "}")
    else error("cannot serialize a " .. t .. "value") end
    if level == 0 then io.write("\n") end
end

local t = {
    "test1",
    nil,
    "test2",
    {
        "test3",
        aaa = {
            [1] = 10,
            [3] = false,
            [2] = true,
            [5] = 5
        },
        bbb = "test4",
    },
    false,
    [true] = ""
}

serialize(t)
serialize(nil)
