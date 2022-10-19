local function is_formatable_val(o)
    local t = type(o)
    return (t == "number" or t == "string" or t == "boolean" or t == "nil")
end

local function serialize_formatable_val(o)
    io.write(string.format("%q", o))
end

local function save(name, value, level, saved, need_repair)
    level = level or 0
    saved = saved or {}
    need_repair = need_repair or {}

    local indentation = string.rep("\t", level)

    -- write variable name
    if level == 0 then
        io.write(string.format("%s = ", name))
    end

    if is_formatable_val(value) then
        serialize_formatable_val(value)

    elseif level == 0 and type(value) == "table" and saved[value] ~= nil then
        need_repair[name] = saved[value]

    elseif type(value) == "table" then
        saved[value] = name
        local number_key_index = 1

        io.write("{\n")
        for child_key, child_value in pairs(value) do
            if not is_formatable_val(child_key) then
                error("cannot serialize a " .. type(child_key) .. " key")
            end

            local child_name = string.format("%s[%q]", name, child_key)

            if type(child_value) == "table" then
                if saved[child_value] ~= nil then
                    need_repair[child_name] = saved[child_value]
                    goto continue
                end
            end

            io.write(indentation, "\t")

            if type(child_key) == "number" and child_key == number_key_index then
                number_key_index = number_key_index + 1
            else
                io.write(string.format("[%q] = ", child_key))
            end

            save(child_name, child_value, level + 1, saved, need_repair)

            io.write(",\n")

            ::continue::
        end
        io.write(indentation .. "}")

    else
        error("cannot serialize a " .. type(value) .. " value")
    end


    if level == 0 then
        io.write("\n")
        for key, value in pairs(need_repair) do
            io.write(string.format("%s = %s\n", key, value))
        end
    end
end

local t1 = {}
t1[1] = t1
local t2 = { 1, 2, t1, {} }
t2[4][2] = t2
local saved = {}
save("t1", t1, 0, saved)
save("t2", t2, 0, saved)
