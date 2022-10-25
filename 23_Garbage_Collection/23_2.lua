o = { x = "hi" }
setmetatable(o, { __gc = function(o) print(o.x) end })
o = nil

-- os.exit(0) -- no output
-- error("this is an error message") -- log error info and then print `hi`
print("This is end")
