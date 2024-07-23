global record BigInteger
  -- Function to check if a value is of type BigInteger
  isbint: function(value: any): boolean

  -- Function to return a bint value of zero
  zero: function(): BigInteger

  -- Constructor function
  new: function(value: number): BigInteger  -- Added constructor function

  -- Arithmetic operations
  metamethod __add: function(a: BigInteger, b: BigInteger): BigInteger
  metamethod __sub: function(a: BigInteger, b: BigInteger): BigInteger
  metamethod __mul: function(a: BigInteger, b: BigInteger): BigInteger
  metamethod __div: function(a: BigInteger, b: BigInteger): BigInteger
  metamethod __idiv: function(a: BigInteger, b: BigInteger): BigInteger

  -- Comparison operations
  metamethod __eq: function(a: BigInteger, b: BigInteger): boolean
  metamethod __lt: function(a: BigInteger, b: BigInteger): boolean
  metamethod __le: function(a: BigInteger, b: BigInteger): boolean

  -- String representation
  metamethod __tostring: function(a: BigInteger): string
end

global record bintModule
  metamethod __call: function(self: bintModule, bits: integer): BigInteger  -- Updated to include self parameter
end
