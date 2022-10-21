-- 练习16.1：通常，在加载代码段时增加一些前缀很有用。（我们在本章前面部分已经见过相应的例子，在那个例子中，我们在待加载的表达式前增加了一个return语句。）
-- 请编写一个函数loadwithprefix，该函数类似于函数load，不过会将第1个参数（一个字符串）增加到待加载的代码段之前。
-- 像原始的load函数一样， 函数loadwithprefix应该既可以接收字符串形式的代码段，也可以通过函数进行读取。即使待加载的代码段是字符串形式的，
-- 函数loadwithprefix也不应该进行实际的字符串连接操作。相反，它应该调用函数load并传入一个恰当的读取函数来实现功能，这个读取函数首先返回要增加的代码，然后返回原始的代码段。

local function loadwithprefix(prefix, chunk)
    local first_call = true
    local last_call = false
    return load(function()
        if first_call then
            first_call = false
            return prefix
        elseif last_call then
            return nil
        elseif type(chunk) == "function" then
            return chunk()
        else
            last_call = true
            return chunk
        end
    end)
end

loadwithprefix("a = ", io.read)()
print(a)
