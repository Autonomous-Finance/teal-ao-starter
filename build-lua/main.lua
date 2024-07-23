local bintMod = require(".bint")
local bintType = bintMod(256)

local greeter = require("greeter")


Info = Info or {
   version = "1.0.0",
   author = "John Doe",
   index = tostring(bintType.zero()),
}


Handlers.add(
"Info",
Handlers.utils.hasMatchingTag("Info"),
function(msg)
   local a = bintType.new(2)
   local b = bintType.new(3)
   if a < b then
      ao.send({
         Target = msg.From,
         Data = json.encode(Info),
      })
   end
end)


Handlers.add(
"Greet",
Handlers.utils.hasMatchingTag("Greet"),
function(msg)
   greeter.greet(msg)
end)
