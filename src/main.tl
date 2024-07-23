local bintMod = require(".bint") as bintModule-- Require the bint module
local bintType = bintMod(256) -- Instantiate it with 256 bits

local greeter = require "greeter"

global Info: {string: string} 
Info = Info or {
  version = "1.0.0",
  author = "John Doe",
  index = tostring(bintType.zero()),
}


Handlers.add(
  "Info",
  Handlers.utils.hasMatchingTag("Info"),
  function(msg: Message)
    local a = bintType.new(2)
    local b = bintType.new(3)
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


