-- 练习5.1：下面代码的输出是什么？为什么？

sunday = "monday";
monday = "sunday";
t = { sunday = "monday", [sunday] = monday }
print(t.sunday, t[sunday], t[t.sunday])
