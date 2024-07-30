local bint = require('bint')(256)


local function i_take_bints(n1, n2)
   return n1:_add(n2)
end


local b1 = bint.new(10)
local b2 = bint.new(20)

local n1 = 10
local n2 = 20

print(i_take_bints(b1, b2))
print(i_take_bints(n1, n2))
