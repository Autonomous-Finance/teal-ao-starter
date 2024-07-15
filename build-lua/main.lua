local json = require("json")

local greeter = require("greeter")


Info = Info or {
   version = "1.0.0",
   author = "John Doe",
}


Handlers.add(
"Info",
Handlers.utils.hasMatchingTag("Info"),
function(msg)
   ao.send({
      Taret = msg.From,
      Data = json.encode(Info),
   })
end)


Handlers.add(
"Greet",
Handlers.utils.hasMatchingTag("Greet"),
function(msg)
   greeter.greet(msg)
end)
