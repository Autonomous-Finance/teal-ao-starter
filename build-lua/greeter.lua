local mod = {}

function mod.greet(msg)
   ao.send({
      Target = msg.From,
      Data = "Hello, " .. msg.Tags.name,
   })
end

return mod
