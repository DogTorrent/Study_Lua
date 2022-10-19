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
