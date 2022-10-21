return {
    disk = function(cx, cy, r)
        return function(x, y)
            return (x - cx) ^ 2 + (y - cy) ^ 2 <= r ^ 2
        end
    end,

    rect = function(left, right, bottom, up)
        return function(x, y)
            return left <= x and right >= x and bottom <= y and up >= y
        end
    end,

    complement = function(r)
        return function(x, y)
            return not r(x, y)
        end
    end,

    union = function(r1, r2)
        return function(x, y)
            return r1(x, y) or r2(x, y)
        end
    end,

    intersection = function(r1, r2)
        return function(x, y)
            return r1(x, y) and r2(x, y)
        end
    end,

    difference = function(r1, r2)
        return function(x, y)
            return r1(x, y) and not r2(x, y)
        end
    end,

    translate = function(r, dx, dy)
        return function(x, y)
            return r(x - dx, y - dy)
        end
    end,

    plot = function(r, width, height)
        io.write("P1\n", width, " ", height, "\n")
        for i = 1, height do
            local y = -(i * 2 - height) / height
            for j = 1, width do
                local x = (j * 2 - width) / width
                io.write(r(x, y) and "1" or "0")
            end
            io.write("\n")
        end
    end,
}
