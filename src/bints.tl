local bint = require('bint')(256)


local function add_bints(n1: BigInteger, n2: BigInteger): BigInteger
    return n1:_add(n2)
end

local function print_bint(n1: BigInteger)
    print(n1)
end


local b1 = bint.new(10)
local b2 = bint.new(20) 

local n1 = 10
local n2 = 20

print_bint(add_bints(b1, b2))
-- print_bint(b1 + b2)
print_bint(n1 + n2)