local print = print
function foo(_ENV, a)
    -- use the local print instead of _ENV.print, because there is no print in the local _ENV here
    print(a + b)
end

foo({ b = 14 }, 12) -- 26
foo({ b = 10 }, 1) -- 11
