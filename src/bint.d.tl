global record BigInteger
  bits: integer

  -- Create a new bint with 0 value
  zero: function(): BigInteger
  -- Create a new bint with 1 value
  one: function(): BigInteger
  -- Create a bint from an unsigned integer
  fromuinteger: function(x: number): BigInteger
  -- Create a bint from a signed integer
  frominteger: function(x: number): BigInteger
  -- Create a bint from a string of the desired base
  frombase: function(s: string, base: integer): BigInteger
  -- Create a new bint from a string (decimal, binary, or hexadecimal)
  fromstring: function(s: string): BigInteger
  -- Create a new bint from a buffer of little-endian bytes
  fromle: function(buffer: string): BigInteger
  -- Create a new bint from a buffer of big-endian bytes
  frombe: function(buffer: string): BigInteger
  -- Create a new bint from a value
  new: function(x: number | string | BigInteger): BigInteger
  -- Convert a value to a bint if possible
  tobint: function(x: number | string | BigInteger, clone: boolean): BigInteger
  -- Convert a value to a bint if possible, otherwise to a lua number
  parse: function(x: number | string | BigInteger, clone: boolean): BigInteger
  -- Convert a bint to an unsigned integer
  touinteger: function(x: BigInteger): integer
  -- Convert a bint to a signed integer
  tointeger: function(x: BigInteger): integer | nil
  -- Convert a bint to a lua float or integer
  tonumber: function(x: BigInteger): number
  -- Convert a bint to a string in the desired base
  tobase: function(x: BigInteger, base: integer, unsigned: boolean): string
  -- Convert a bint to a buffer of little-endian bytes
  tole: function(x: BigInteger, trim: boolean): string
  -- Convert a bint to a buffer of big-endian bytes
  tobe: function(x: BigInteger, trim: boolean): string

  -- Check if a number is 0 considering bints
  iszero: function(x: BigInteger): boolean
  -- Check if a number is 1 considering bints
  isone: function(x: BigInteger): boolean
  -- Check if a number is -1 considering bints
  isminusone: function(x: BigInteger): boolean
  -- Check if the input is a bint
  isbint: function(x: any): boolean
  -- Check if the input is a lua integer or a bint
  isintegral: function(x: any): boolean
  -- Check if the input is a bint or a lua number
  isnumeric: function(x: any): boolean
  -- Get the number type of the input (bint, integer or float)
  type: function(x: any): string | nil
  -- Check if a number is negative considering bints
  isneg: function(x: BigInteger): boolean
  -- Check if a number is positive considering bints
  ispos: function(x: BigInteger): boolean
  -- Check if a number is even considering bints
  iseven: function(x: BigInteger): boolean
  -- Check if a number is odd considering bints
  isodd: function(x: BigInteger): boolean

  -- Create a new bint with the maximum possible integer value
  maxinteger: function(): BigInteger
  -- Create a new bint with the minimum possible integer value
  mininteger: function(): BigInteger

  -- Increment a number by one considering bints
  inc: function(x: BigInteger): BigInteger
  -- Decrement a number by one considering bints
  dec: function(x: BigInteger): BigInteger
  -- Take absolute of a number considering bints
  abs: function(x: BigInteger): BigInteger
  -- Take the floor of a number considering bints
  floor: function(x: BigInteger): BigInteger
  -- Take ceil of a number considering bints
  ceil: function(x: BigInteger): BigInteger
  -- Wrap around bits of an integer (discarding left bits) considering bints
  bwrap: function(x: BigInteger, y: integer): BigInteger
  -- Rotate left integer x by y bits considering bints
  brol: function(x: BigInteger, y: integer): BigInteger
  -- Rotate right integer x by y bits considering bints
  bror: function(x: BigInteger, y: integer): BigInteger
  -- Take maximum between two numbers considering bints
  max: function(x: BigInteger, y: BigInteger): BigInteger
  -- Take minimum between two numbers considering bints
  min: function(x: BigInteger, y: BigInteger): BigInteger

  -- Perform unsigned division and modulo operation between two integers considering bints
  udivmod: function(x: BigInteger, y: BigInteger): BigInteger, BigInteger
  -- Perform unsigned division between two integers considering bints
  udiv: function(x: BigInteger, y: BigInteger): BigInteger
  -- Perform unsigned integer modulo operation between two integers considering bints
  umod: function(x: BigInteger, y: BigInteger): BigInteger
  -- Perform integer truncate division and modulo operation between two numbers considering bints
  tdivmod: function(x: BigInteger, y: BigInteger): BigInteger, BigInteger
  -- Perform truncate division between two numbers considering bints
  tdiv: function(x: BigInteger, y: BigInteger): BigInteger
  -- Perform integer truncate modulo operation between two numbers considering bints
  tmod: function(x: BigInteger, y: BigInteger): BigInteger
  -- Perform integer floor division and modulo operation between two numbers considering bints
  idivmod: function(x: BigInteger, y: BigInteger): BigInteger, BigInteger

  -- Perform integer power between two BigIntegers
  ipow: function(x: BigInteger, y: BigInteger): BigInteger
  -- Perform integer power between two unsigned integers over a modulus considering bints
  upowmod: function(x: integer, y: integer, m: integer): BigInteger

  -- Compare if integer x is less than y considering bints (unsigned version)
  ult: function(x: BigInteger, y: BigInteger): boolean
  -- Compare if bint x is less or equal than y considering bints (unsigned version)
  ule: function(x: BigInteger, y: BigInteger): boolean

  -- Check if numbers are equal considering bints
  eq: function(x: BigInteger, y: BigInteger): boolean

  -- Add an integer to a bint (in-place)
  _add: function(self: BigInteger, y: BigInteger): BigInteger
  -- Subtract an integer from a bint (in-place)
  _sub: function(self: BigInteger, y: BigInteger): BigInteger
  -- Increment a bint by one (in-place)
  _inc: function(self: BigInteger): BigInteger
  -- Decrement a bint by one (in-place)
  _dec: function(self: BigInteger): BigInteger
  -- Assign a bint to a new value (in-place)
  _assign: function(self: BigInteger, y: BigInteger): BigInteger
  -- Take absolute of a bint (in-place)
  _abs: function(self: BigInteger): BigInteger
  -- Bitwise left shift a bint in one bit (in-place)
  _shlone: function(self: BigInteger): BigInteger
  -- Bitwise right shift a bint in one bit (in-place)
  _shrone: function(self: BigInteger): BigInteger
  -- Bitwise left shift words of a bint (in-place)
  _shlwords: function(self: BigInteger, n: integer): BigInteger
  -- Bitwise right shift words of a bint (in-place)
  _shrwords: function(self: BigInteger, n: integer): BigInteger
  -- Bitwise AND bints (in-place)
  _band: function(self: BigInteger, y: BigInteger): BigInteger
  -- Bitwise OR bints (in-place)
  _bor: function(self: BigInteger, y: BigInteger): BigInteger
  -- Bitwise XOR bints (in-place)
  _bxor: function(self: BigInteger, y: BigInteger): BigInteger
  -- Bitwise NOT a bint (in-place)
  _bnot: function(self: BigInteger): BigInteger
  -- Negate a bint (in-place)
  _unm: function(self: BigInteger): BigInteger

  -- Add two numbers considering bints
  __add: function(self: BigInteger, y: BigInteger): BigInteger
  -- Subtract two numbers considering bints
  __sub: function(self: BigInteger, y: BigInteger): BigInteger
  -- Multiply two numbers considering bints
  __mul: function(self: BigInteger, y: BigInteger): BigInteger
  -- Perform division between two numbers considering bints
  __div: function(self: BigInteger, y: BigInteger): number
  -- Perform floor division between two numbers considering bints
  __idiv: function(self: BigInteger, y: BigInteger): BigInteger, BigInteger
  -- Perform integer floor modulo operation between two numbers considering bints
  __mod: function(self: BigInteger, y: BigInteger): BigInteger
  -- Perform numeric power between two numbers considering bints
  __pow: function(self: BigInteger, y: BigInteger): BigInteger
  -- Negate a bint
  __unm: function(self: BigInteger): BigInteger
  -- Bitwise AND two integers considering bints
  __band: function(self: BigInteger, x: BigInteger, y:BigInteger): BigInteger
  -- Bitwise OR two integers considering bints
  __bor: function(self: BigInteger, y: BigInteger): BigInteger
  -- Bitwise XOR two integers considering bints
  __bxor: function(self: BigInteger, y: BigInteger): BigInteger
  -- Bitwise NOT a bint
  __bnot: function(self: BigInteger): BigInteger
  -- Bitwise left shift integers considering bints
  __shl: function(self: BigInteger, y: integer): BigInteger
  -- Bitwise right shift integers considering bints
  __shr: function(self: BigInteger, y: integer): BigInteger
  -- Compare if number x is less than y considering bints and signs
  lt: function(self: BigInteger, y: BigInteger): boolean
  __lt: function(self: BigInteger, y: BigInteger): boolean
  gt: function(self: BigInteger, y: BigInteger): boolean
  -- Compare if number x is less or equal than y considering bints and signs
  le: function(self: BigInteger, y: BigInteger): boolean
  __le: function(self: BigInteger, y: BigInteger): boolean
  ge: function(self: BigInteger, y: BigInteger): boolean
  -- Check if bints are equal
  __eq: function(self: BigInteger, y: BigInteger): boolean
  -- Convert a bint to a string on base 10
  __tostring: function(self: BigInteger): string

  -- Allow creating bints by calling bint itself
  __call: function(self: BigInteger, x: number | string | BigInteger): BigInteger

  __index: any

  -- Add two numbers considering bints
  metamethod __add: function(self: BigInteger, y: BigInteger): BigInteger
  -- Subtract two numbers considering bints
  metamethod __sub: function(self: BigInteger, y: BigInteger): BigInteger
  -- Multiply two numbers considering bints
  metamethod __mul: function(self: BigInteger, y: BigInteger): BigInteger
  -- Perform division between two numbers considering bints
  metamethod __div: function(self: BigInteger, y: BigInteger): number
  -- Perform floor division between two numbers considering bints
  metamethod __idiv: function(self: BigInteger, y: BigInteger): BigInteger
  -- Perform integer floor modulo operation between two numbers considering bints
  metamethod __mod: function(self: BigInteger, y: BigInteger): BigInteger
  -- Perform numeric power between two numbers considering bints
  metamethod __pow: function(self: BigInteger, y: BigInteger): BigInteger
  -- Negate a bint
  metamethod __unm: function(self: BigInteger): BigInteger
  -- Bitwise AND two integers considering bints
  metamethod __band: function(self: BigInteger, x: BigInteger, y:BigInteger): BigInteger
  -- Bitwise OR two integers considering bints
  metamethod __bor: function(self: BigInteger, y: BigInteger): BigInteger
  -- Bitwise XOR two integers considering bints
  metamethod __bxor: function(self: BigInteger, y: BigInteger): BigInteger
  -- Bitwise NOT a bint
  metamethod __bnot: function(self: BigInteger): BigInteger
  -- Bitwise left shift integers considering bints
  metamethod __shl: function(self: BigInteger, y: integer): BigInteger
  -- Bitwise right shift integers considering bints
  metamethod __shr: function(self: BigInteger, y: integer): BigInteger
  -- Compare if number x is less than y considering bints and signs
  metamethod __lt: function(self: BigInteger, y: BigInteger): boolean
  -- Compare if number x is less or equal than y considering bints and signs
  metamethod __le: function(self: BigInteger, y: BigInteger): boolean
  -- Check if bints are equal
  metamethod __eq: function(self: BigInteger, y: BigInteger): boolean
  -- Convert a bint to a string on base 10
  metamethod __tostring: function(self: BigInteger): string

  metamethod __index: function(self: BigInteger, key: integer): integer
  -- Allow creating bints by calling bint itself
  metamethod __call: function(self: BigInteger, x: number | string | BigInteger): BigInteger


end

global record bintModule
  metamethod __call: function(self: bintModule, bits: integer): BigInteger  -- Updated to include self parameter
end
