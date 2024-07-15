local json = require "json" as json

local greeter = require "greeter"

global Info: {string: string} 
Info = Info or {
  version = "1.0.0",
  author = "John Doe"
}


Handlers.add(
  "Info",
  Handlers.utils.hasMatchingTag("Info"),
  function(msg: Message)
    ao.send({
      Taret = msg.From,
      Data = json.encode(Info)
    })
  end
)

Handlers.add(
  "Greet",
  Handlers.utils.hasMatchingTag("Greet"),
  function(msg: Message)
    greeter.greet(msg)
  end
)


