-- 练习14.1：请编写一个函数，该函数用于两个稀疏矩阵相加。

local function matrix_add(m1, m2)
    local f1, stat1 = pairs(m1)
    local f2, stat2 = pairs(m2)
    local y1, row1 = f1(stat1)
    local y2, row2 = f2(stat2)
    local m = {}
    while y1 ~= nil or y2 ~= nil do
        if y2 == nil or (y1 and y1 <= y2) then
            m[y1] = m[y1] or {}
            for x1, value in pairs(row1) do
                m[y1][x1] = (m[y1][x1] or 0) + value
                m[y1][x1] = m[y1][x1] ~= 0 and m[y1][x1] or nil
            end
        end

        if y1 == nil or (y2 and y2 <= y1) then
            m[y2] = m[y2] or {}
            for x2, value in pairs(row2) do
                m[y2][x2] = (m[y2][x2] or 0) + value
                m[y2][x2] = m[y2][x2] ~= 0 and m[y2][x2] or nil
            end
        end

        if y2 == nil or (y1 and y1 < y2) then y1, row1 = f1(stat1, y1)
        elseif y1 == nil or (y2 and y2 < y1) then y2, row2 = f2(stat2, y2)
        else
            y1, row1 = f1(stat1, y1)
            y2, row2 = f2(stat2, y2)
        end
    end
    return m
end

local m1 = {
    { 1, 1, 1, nil, 1 },
    { 2, 2, 2, nil, 2 },
    { 3, 3, 3, nil, 3 },
}

local m2 = {
    { 1, 2, nil, 3 },
    { 1, 2, nil, 3 },
    { 1, 2, nil, 3 },
}

local m = matrix_add(m1, m2)

for y, line in ipairs(m) do
    for x, val in ipairs(line) do
        io.write(val, " ")
    end
    io.write("\n")
end
