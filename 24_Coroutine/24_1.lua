-- 练习24.1：使用生产者驱动（producer-driven）式设计重写24.2节中生产者-消费者的示例，其中消费者是协程，而生产者是主线程。

local consume_co

local function send(x)
    coroutine.resume(consume_co, x)
end

local function receive()
    return coroutine.yield()
end

local function produce()
    while true do
        send(io.read())
    end
end

local function consume()
    while true do
        io.write(receive(), "\n")
    end
end

consume_co = coroutine.create(consume)
coroutine.resume(consume_co)
produce()
