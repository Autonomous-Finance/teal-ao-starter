local mod = {}

function mod.greet(msg: Message)
    ao.send({
        Target = msg.From,
        Data = "Hello, " .. msg.Tags.name
    })
end

return mod