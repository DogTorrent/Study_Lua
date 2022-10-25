function getfield(f)
    local v = _G
    for word, split in string.gmatch(f, "([%a_][%w_]*)([^%a_]*)") do
        if split == "." or split == "" then
            v = v[word]
        else
            error("Invalid field string!")
        end
    end
    return v
end

print(getfield("math.sin"))
-- print(getfield("math?sin"))
-- print(getfield("math..sin"))
