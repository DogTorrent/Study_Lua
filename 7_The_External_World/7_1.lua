-- 练习7.1：请编写一个程序，该程序读取一个文本文件然后将每行的内容按照字母表顺序排序后重写该文件。
-- 如果调用时不带参数，则从标准输入读取并向标准输出写入；
-- 如果调用时传入一个文件名作为参数，则从该文件中读取并向标准输出写入；
-- 如果调用时传入两个文件名作为参数，则从第一个文件读取并将结果写入第二个文件中。

origin_input = io.input()
origin_output = io.output()
if arg[1] then io.input(arg[1]) else io.input(io.stdin) end
if arg[2] then io.output(arg[2]) else io.output(io.stdout) end
local lines = {}
for line in io.lines() do
    table.insert(lines, {})
    for i = 1, #line do
        table.insert(lines[#lines], string.sub(line, i, i))
    end
    table.sort(lines[#lines])
end
for i = 1, #lines do
    for j = 1, #lines[i] do
        io.write(lines[i][j])
    end
    io.write("\n")
end
io.close()
io.input(origin_input)
io.output(origin_output)
