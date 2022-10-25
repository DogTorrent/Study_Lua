-- 用table包裹即可
do
    local memorized_result = setmetatable({}, { __mode = "v" })
    function addline(str)
        local result = memorized_result[str]
        if result == nil then
            result = { s = "_" .. str }
            memorized_result[str] = result
            print("create result string:", result.s)
        else
            print("reuse result string:", result.s)
        end
        return result.s
    end

    addline("test")
    addline("test")
    collectgarbage()
    addline("test")
end
