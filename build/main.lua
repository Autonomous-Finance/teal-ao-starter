do
local _ENV = _ENV
package.preload[ "greeter" ] = function( ... ) local arg = _G.arg;
local mod = {}

function mod.greet(msg)
   ao.send({
      Target = msg.From,
      Data = "Hello, " .. msg.Tags.name,
   })
end

return mod
end
end

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
