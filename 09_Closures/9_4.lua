-- 练习9.4：使用几何区域系统的例子，绘制一个北半球（northern hemisphere）所能看到的蛾眉月（waxing crescent moon）。

local function disk(cx, cy, r)
    return function(x, y)
        return (x - cx) ^ 2 + (y - cy) ^ 2 <= r ^ 2
    end
end

local function rect(left, right, bottom, up)
    return function(x, y)
        return left <= x and right >= x and bottom <= y and up >= y
    end
end

local function complement(r)
    return function(x, y)
        return not r(x, y)
    end
end

local function union(r1, r2)
    return function(x, y)
        return r1(x, y) or r2(x, y)
    end
end

local function intersection(r1, r2)
    return function(x, y)
        return r1(x, y) and r2(x, y)
    end
end

local function difference(r1, r2)
    return function(x, y)
        return r1(x, y) and not r2(x, y)
    end
end

local function translate(r, dx, dy)
    return function(x, y)
        return r(x - dx, y - dy)
    end
end

local function plot(r, width, height)
    io.write("P1\n", width, " ", height, "\n")
    for i = 1, height do
        local y = -(i * 2 - height) / height
        for j = 1, width do
            local x = (j * 2 - width) / width
            io.write(r(x, y) and "1" or "0")
        end
        io.write("\n")
    end
end

local function draw_picture_file(plot_f, filename)
    old_output = io.output()
    io.output(filename)
    plot_f()
    io.close()
    io.output(old_output)
end

local c1 = disk(0, 0, 1)
local output_file = string.sub(arg[0], 1, -string.find(string.reverse(arg[0]), "[/\\]")) .. "moon_9_4.pbm"
draw_picture_file(function() plot(difference(c1, translate(c1, -0.3, 0)), 500, 500) end, output_file)
