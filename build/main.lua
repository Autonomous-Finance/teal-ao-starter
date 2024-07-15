do
local _ENV = _ENV
package.preload[ "greeter" ] = function( ... ) local arg = _G.arg;
local mod = {}

function mod.greet(name)
   print("Hello, " .. name)
end

return mod
end
end

local greeter = require("greeter")

greeter.greet("world")
