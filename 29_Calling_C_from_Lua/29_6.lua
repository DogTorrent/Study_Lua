package.cpath = package.cpath .. ";?.dll"
local mylib = require("mylib")

-- print(mylib.summation())
-- print(mylib.summation(1.5, 2, 3.2, 10))

-- print(table.unpack(mylib.pack("aaa", 10, 1, nil, 0)))

-- print(mylib.reverse(1, "hello", 20))

mylib.foreach({ a = "aaa", [1] = 0 }, print);
mylib.foreach({ a = "aaa", [1] = 0 }, print);
