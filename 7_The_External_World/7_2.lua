-- 练习7.2：改写7.1的程序，使得当指定的输出文件已经存在时，要求用户确认。

local input = io.stdin
local output = io.stdout
if arg[1] then input = io.open(arg[1]) end
if arg[2] then
    local f = io.open(arg[2])
    if f then
        f:close()
        while check ~= "Y" and check ~= "N" do
            io.stdout:write("Output file exist!\nContinue?[Y/N]: ")
            check = io.stdin:read("l")
        end
        if check == "N" then return end
    end
    output = io.open(arg[2], "w")
end
local lines = {}
for line in input:lines() do
    table.insert(lines, {})
    for pos, code in utf8.codes(line) do
        table.insert(lines[#lines], code)
    end
    table.sort(lines[#lines])
end
input:close()
for i = 1, #lines do
    for j = 1, #lines[i] do
        output:write(utf8.char(lines[i][j]))
    end
    output:write("\n")
end
output:close()
