global record bint
  -- Function to check if a value is of type bint
  isbint: function(value: any): boolean

  -- Function to return a bint value of zero
  zero: function(): bint

  -- Constructor function
  new: function(value: number): bint  -- Added constructor function

  -- Arithmetic operations
  metamethod __add: function(a: bint, b: bint): bint
  metamethod __sub: function(a: bint, b: bint): bint
  metamethod __mul: function(a: bint, b: bint): bint
  metamethod __div: function(a: bint, b: bint): bint
  metamethod __idiv: function(a: bint, b: bint): bint

  -- Comparison operations
  metamethod __eq: function(a: bint, b: bint): boolean
  metamethod __lt: function(a: bint, b: bint): boolean
  metamethod __le: function(a: bint, b: bint): boolean

  -- String representation
  metamethod __tostring: function(a: bint): string
end

global record bintModule
  metamethod __call: function(self: bintModule, bits: integer): bint  -- Updated to include self parameter

  -- Other bint functions
  isbint: function(value: any): boolean
  zero: function(): bint
end
