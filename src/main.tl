local bintMod = require(".bint") as bintModule-- Require the bint module
local bint = bintMod(256) -- Instantiate it with 256 bits

local greeter = require "greeter"

global Info: {string: string} 
Info = Info or {
  version = "1.0.0",
  author = "John Doe",
  index = tostring(bint.zero()),
}


Handlers.add(
  "Info",
  Handlers.utils.hasMatchingTag("Info"),
  function(msg: Message)
    local a = bint.new(2)
    local b = bint.new(3)
    if a < b then
      ao.send({
        Target = msg.From,
        Data = json.encode(Info)
      })
    end
  end
)

Handlers.add(
  "Greet",
  Handlers.utils.hasMatchingTag("Greet"),
  function(msg: Message)
    greeter.greet(msg)
  end
)


