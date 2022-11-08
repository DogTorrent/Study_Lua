-- 练习4.1：请问如何在Lua程序中以字符串的方式使用如下的XML片段，请给出至少两种实现方式。
-- <! [CDATA[
--     Hello world
-- ]]>

s = [=[
<![CDATA[
    Hello world
]]>]=]
print(s)
s = "<![CDATA[\n    Hello world\n]]>"
print(s)
