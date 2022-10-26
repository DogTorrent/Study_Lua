-- 练习22.2：请详细解释下列程序做了什么，以及输出的结果是什么。

local foo
do
    local _ENV = _ENV
    function foo() print(X) end
end
X = 13
_ENV = nil
foo()
X = 0 -- error: attempt to index a nil value (upvalue '_ENV')
