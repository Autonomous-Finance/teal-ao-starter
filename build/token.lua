do
local _ENV = _ENV
package.preload[ "dummy.dummy" ] = function( ... ) local arg = _G.arg;
function print_dummy(n)
    print("dummy print:", n)
end

return {
    print_dummy = print_dummy
}
end
end

do
local _ENV = _ENV
package.preload[ "token.utils.bint" ] = function( ... ) local arg = _G.arg;
local _tl_compat; if (tonumber((_VERSION or ''):match('[%d.]*$')) or 0) < 5.3 then local p, m = pcall(require, 'compat53.module'); if p then _tl_compat = m end end; local assert = _tl_compat and _tl_compat.assert or assert; local debug = _tl_compat and _tl_compat.debug or debug; local math = _tl_compat and _tl_compat.math or math; local _tl_math_maxinteger = math.maxinteger or math.pow(2, 53); local _tl_math_mininteger = math.mininteger or -math.pow(2, 53) - 1; local string = _tl_compat and _tl_compat.string or string; local table = _tl_compat and _tl_compat.table or table; local _tl_table_unpack = unpack or table.unpack; BigInteger = {}

































































































































































































































local function luainteger_bitsize()
   local n = -1
   local i = 0
   repeat
      n, i = n >> 16, i + 16
   until n == 0
   return i
end

local math_type = math.type
local math_floor = math.floor
local math_abs = math.abs
local math_ceil = math.ceil
local math_modf = math.modf
local math_mininteger = _tl_math_mininteger
local math_maxinteger = _tl_math_maxinteger
local math_max = math.max
local math_min = math.min
local string_format = string.format
local table_insert = table.insert
local table_concat = table.concat
local table_unpack = _tl_table_unpack

local memo = {}








local function newmodule(bits, wordbits)

   local intbits = luainteger_bitsize()
   bits = bits or 256
   wordbits = wordbits or (intbits // 2)


   local memoindex = bits * 64 + wordbits
   if memo[memoindex] then
      return memo[memoindex]
   end


   assert(bits % wordbits == 0, 'bitsize is not multiple of word bitsize')
   assert(2 * wordbits <= intbits, 'word bitsize must be half of the lua integer bitsize')
   assert(bits >= 64, 'bitsize must be >= 64')
   assert(wordbits >= 8, 'wordbits must be at least 8')
   assert(bits % 8 == 0, 'bitsize must be multiple of 8')


   local bint = {}
   bint.__index = bint


   bint.bits = bits


   local BINT_BITS = bits
   local BINT_BYTES = bits // 8
   local BINT_WORDBITS = wordbits
   local BINT_SIZE = BINT_BITS // BINT_WORDBITS
   local BINT_WORDMAX = (1 << BINT_WORDBITS) - 1
   local BINT_WORDMSB = (1 << (BINT_WORDBITS - 1))
   local BINT_LEPACKFMT = '<' .. ('I' .. (wordbits // 8)):rep(BINT_SIZE)
   local BINT_MATHMININTEGER
   local BINT_MATHMAXINTEGER
   local BINT_MININTEGER


   function bint.zero()
      local x = setmetatable({}, bint)
      for i = 1, BINT_SIZE do
         x[i] = 0
      end
      return x
   end
   local bint_zero = bint.zero


   function bint.one()
      local x = setmetatable({}, bint)
      x[1] = 1
      for i = 2, BINT_SIZE do
         x[i] = 0
      end
      return x
   end
   local bint_one = bint.one


   local function tointeger(x)
      x = tonumber(x)
      local ty = math_type(x)
      if ty == 'float' then
         local floorx = math_floor(x)
         if floorx == x then
            x = floorx
            ty = math_type(x)
         end
      end
      if ty == 'integer' then
         return x
      end
   end






   function bint.fromuinteger(x)
      x = tointeger(x)
      if x then
         if x == 1 then
            return bint_one()
         elseif x == 0 then
            return bint_zero()
         end
         local n = setmetatable({}, bint)
         for i = 1, BINT_SIZE do
            n[i] = x & BINT_WORDMAX
            x = x >> BINT_WORDBITS
         end
         return n
      end
   end
   local bint_fromuinteger = bint.fromuinteger





   function bint.frominteger(x)
      x = tointeger(x)
      if x then
         if x == 1 then
            return bint_one()
         elseif x == 0 then
            return bint_zero()
         end
         local neg = false
         if x < 0 then
            x = math_abs(x)
            neg = true
         end
         local n = setmetatable({}, bint)
         for i = 1, BINT_SIZE do
            n[i] = x & BINT_WORDMAX
            x = x >> BINT_WORDBITS
         end
         if neg then
            n:_unm()
         end
         return n
      end
   end
   local bint_frominteger = bint.frominteger


   local basesteps = {}


   local function getbasestep(base)
      local step = basesteps[base]
      if step then
         return step
      end
      step = 0
      local dmax = 1
      local limit = math_maxinteger // base
      repeat
         step = step + 1
         dmax = dmax * base
      until dmax >= limit
      basesteps[base] = step
      return step
   end


   local function ipow(y, x, n)
      if n == 1 then
         return y * x
      elseif n & 1 == 0 then
         return ipow(y, x * x, n // 2)
      end
      return ipow(x * y, x * x, (n - 1) // 2)
   end




   function bint.isbint(x)
      return getmetatable(x) == bint
   end


   local function bint_assert_convert(x)
      if not bint.isbint(x) then
         print(debug.traceback())
         assert(bint.isbint(x), 'bint_assert_convert: expected BigInteger, got ' .. type(x) .. ' value ' .. tostring(x))
      end
      return x
   end


   local function bint_assert_convert_clone(x)
      if not bint.isbint(x) then
         print(debug.traceback())
         assert(bint.isbint(x), 'bint_assert_convert_clone: expected BigInteger, got ' .. type(x) .. ' value ' .. tostring(x))
      end
      local n = setmetatable({}, bint)
      local xi = x
      for i = 1, BINT_SIZE do
         n[i] = xi[i]
      end
      return n
   end


   local function bint_assert_convert_from_integer(x)
      local xi = bint_frominteger(x)
      assert(xi, 'bint_assert_convert_from_integer: could not convert integer to big integer' .. type(x) .. ' value ' .. tostring(x))
      return xi
   end







   function bint.frombase(s, base)
      if type(s) ~= 'string' then
         error('s is not a string')
      end
      base = base or 10
      if not (base >= 2 and base <= 36) then
         error('number base is too large')
      end
      local step = getbasestep(base)
      if #s < step then

         return bint_frominteger(tonumber(s, base))
      end
      local sign
      local int
      sign, int = s:lower():match('^([+-]?)(%w+)$')
      if not (sign and int) then
         error('invalid integer string representation')
      end
      local n = bint_zero()
      for i = 1, #int, step do
         local part = int:sub(i, i + step - 1)
         local d = tonumber(part, base)
         if not d then
            error('invalid integer string representation')
         end
         if i > 1 then
            n = n * bint_frominteger(ipow(1, base, #part))
         end
         if d ~= 0 then
            n:_add(bint_frominteger(d))
         end
      end
      if sign == '-' then
         n:_unm()
      end
      return n
   end
   local bint_frombase = bint.frombase






   function bint.fromstring(s)
      if type(s) ~= 'string' then
         error('s is not a string')
      end
      if s:find('^[+-]?[0-9]+$') then
         return bint_frombase(s, 10)
      elseif s:find('^[+-]?0[xX][0-9a-fA-F]+$') then
         return bint_frombase(s:gsub('0[xX]', '', 1), 16)
      elseif s:find('^[+-]?0[bB][01]+$') then
         return bint_frombase(s:gsub('0[bB]', '', 1), 2)
      end
   end
   local bint_fromstring = bint.fromstring





   function bint.fromle(buffer)
      assert(type(buffer) == 'string', 'buffer is not a string')
      if #buffer > BINT_BYTES then
         buffer = buffer:sub(1, BINT_BYTES)
      elseif #buffer < BINT_BYTES then
         buffer = buffer .. ('\x00'):rep(BINT_BYTES - #buffer)
      end
      return setmetatable({ BINT_LEPACKFMT:unpack(buffer) }, bint)
   end





   function bint.frombe(buffer)
      assert(type(buffer) == 'string', 'buffer is not a string')
      if #buffer > BINT_BYTES then
         buffer = buffer:sub(-BINT_BYTES, #buffer)
      elseif #buffer < BINT_BYTES then
         buffer = ('\x00'):rep(BINT_BYTES - #buffer) .. buffer
      end
      return setmetatable({ BINT_LEPACKFMT:unpack(buffer:reverse()) }, bint)
   end







   function bint.new(x)
      if getmetatable(x) ~= bint then
         local ty = type(x)
         if ty == 'number' then
            x = bint_frominteger(x)
            assert(x, 'value cannot be represented by a bint')
            return x
         elseif ty == 'string' then
            x = bint_fromstring(x)
            assert(x, 'value cannot be represented by a bint')
            return x
         end
      end

      return bint_assert_convert_clone(x)
   end
   local bint_new = bint.new









   function bint.tobint(x, clone)
      if getmetatable(x) == bint then
         if not clone then
            return bint_assert_convert(x)
         end

         return bint_assert_convert_clone(x)
      end
      local ty = type(x)
      if ty == 'number' then
         return bint_frominteger(x)
      elseif ty == 'string' then
         return bint_fromstring(x)
      end
   end
   local tobint = bint.tobint

   function bint.touinteger(x)
      if getmetatable(x) == bint then
         local n = 0
         local xi = bint_assert_convert_clone(x)
         for i = 1, BINT_SIZE do
            n = n | (xi[i] << (BINT_WORDBITS * (i - 1)))
         end
         return n
      end
      return tointeger(x)
   end









   function bint.tointeger(x)
      if getmetatable(x) == bint then
         local xi = bint_assert_convert_clone(x)
         local n = 0
         for i = 1, BINT_SIZE do
            n = n | (xi[i] << (BINT_WORDBITS * (i - 1)))
         end
         return n
      end
      return tointeger(x)
   end

   local bint_tointeger = bint.tointeger

   local function bint_assert_tointeger(x)
      local xi = bint_tointeger(x)
      if not xi then
         error('bint_assert_tointeger: cannot convert to integer, got ' .. type(x) .. ' value ' .. tostring(x))
      end
      return xi
   end







   function bint.tonumber(x)
      x = bint_assert_convert_clone(x)
      if x:le(BINT_MATHMAXINTEGER) and x:ge(BINT_MATHMININTEGER) then
         return x:tointeger()
      end
      print('warning: too big for int, casting to number, potential precision loss')
      return tonumber(x)
   end
   local bint_tonumber = bint.tonumber


   local BASE_LETTERS = {}
   do
      for i = 1, 36 do
         BASE_LETTERS[i - 1] = ('0123456789abcdefghijklmnopqrstuvwxyz'):sub(i, i)
      end
   end










   function bint.tobase(x, base, unsigned)
      x = bint_assert_convert_clone(x)
      if not x then
         error('x is a fractional float or something else')
      end
      base = base or 10
      if not (base >= 2 and base <= 36) then

         return
      end
      if unsigned == nil then
         unsigned = base ~= 10
      end
      local isxneg = x:isneg()
      if (base == 10 and not unsigned) or (base == 16 and unsigned and not isxneg) then
         if x:le(BINT_MATHMAXINTEGER) and x:ge(BINT_MATHMININTEGER) then

            local n = x:tointeger()
            if base == 10 then
               return tostring(n)
            elseif unsigned then
               return string_format('%x', n)
            end
         end
      end
      local ss = {}
      local neg = not unsigned and isxneg
      x = neg and x:abs() or bint_new(x)
      local xiszero = x:iszero()
      if xiszero then
         return '0'
      end

      local step = 0
      local basepow = 1
      local limit = (BINT_WORDMSB - 1) // base
      repeat
         step = step + 1
         basepow = basepow * base
      until basepow >= limit

      local size = BINT_SIZE
      local xd
      local carry
      local d
      repeat

         carry = 0
         xiszero = true
         for i = size, 1, -1 do
            carry = carry | x[i]
            d, xd = carry // basepow, carry % basepow
            if xiszero and d ~= 0 then
               size = i
               xiszero = false
            end
            x[i] = d
            carry = xd << BINT_WORDBITS
         end

         for _ = 1, step do
            xd, d = xd // base, xd % base
            if xiszero and xd == 0 and d == 0 then

               break
            end
            table_insert(ss, 1, BASE_LETTERS[d])
         end
      until xiszero
      if neg then
         table_insert(ss, 1, '-')
      end
      return table_concat(ss)
   end








   function bint.tole(x, trim)
      x = bint_assert_convert_clone(x)
      local s = BINT_LEPACKFMT:pack(table_unpack(x))
      if trim then
         s = s:gsub('\x00+$', '')
         if s == '' then
            s = '\x00'
         end
      end
      return s
   end






   function bint.tobe(x, trim)
      x = bint_assert_convert_clone(x)
      local xt = { table_unpack(x) }
      local s = BINT_LEPACKFMT:pack(table_unpack(xt)):reverse()
      if trim then
         s = s:gsub('^\x00+', '')
         if s == '' then
            s = '\x00'
         end
      end
      return s
   end



   function bint.iszero(x)
      local xi = bint_assert_convert(x)
      for i = 1, BINT_SIZE do
         if xi[i] ~= 0 then
            return false
         end
      end
      return true
   end



   function bint.isone(x)
      local xi = bint_assert_convert(x)
      if xi[1] ~= 1 then
         return false
      end
      for i = 2, BINT_SIZE do
         if xi[i] ~= 0 then
            return false
         end
      end
      return true
   end



   function bint.isminusone(x)
      local xi = bint_assert_convert(x)
      if xi[1] ~= BINT_WORDMAX then
         return false
      end
      return true
   end
   local bint_isminusone = bint.isminusone



   function bint.isintegral(x)
      return getmetatable(x) == bint or math_type(x) == 'integer'
   end



   function bint.isnumeric(x)
      return getmetatable(x) == bint or type(x) == 'number'
   end





   function bint.type(x)
      if getmetatable(x) == bint then
         return 'bint'
      end
      return math_type(x)
   end




   function bint.isneg(x)
      bint_assert_convert(x)
      return x[BINT_SIZE] & BINT_WORDMSB ~= 0
   end
   local bint_isneg = bint.isneg



   function bint.ispos(x)
      bint_assert_convert(x)
      return not x:isneg() and not x:iszero()
   end



   function bint.iseven(x)
      bint_assert_convert(x)
      return x[1] & 1 == 0
   end



   function bint.isodd(x)
      bint_assert_convert(x)
      return x[1] & 1 == 1
   end


   function bint.maxinteger()
      local x = setmetatable({}, bint)
      for i = 1, BINT_SIZE - 1 do
         x[i] = BINT_WORDMAX
      end
      x[BINT_SIZE] = BINT_WORDMAX ~ BINT_WORDMSB
      return x
   end


   function bint.mininteger()
      local x = setmetatable({}, bint)
      for i = 1, BINT_SIZE - 1 do
         x[i] = 0
      end
      x[BINT_SIZE] = BINT_WORDMSB
      return x
   end


   function bint:_shlone()
      local wordbitsm1 = BINT_WORDBITS - 1
      for i = BINT_SIZE, 2, -1 do
         self[i] = ((self[i] << 1) | (self[i - 1] >> wordbitsm1)) & BINT_WORDMAX
      end
      self[1] = (self[1] << 1) & BINT_WORDMAX
      return self
   end


   function bint:_shrone()
      local wordbitsm1 = BINT_WORDBITS - 1
      for i = 1, BINT_SIZE - 1 do
         self[i] = ((self[i] >> 1) | (self[i + 1] << wordbitsm1)) & BINT_WORDMAX
      end
      self[BINT_SIZE] = self[BINT_SIZE] >> 1
      return self
   end


   function bint:_shlwords(n)
      for i = BINT_SIZE, n + 1, -1 do
         self[i] = self[i - n]
      end
      for i = 1, n do
         self[i] = 0
      end
      return self
   end


   function bint:_shrwords(n)
      if n < BINT_SIZE then
         for i = 1, BINT_SIZE - n do
            self[i] = self[i + n]
         end
         for i = BINT_SIZE - n + 1, BINT_SIZE do
            self[i] = 0
         end
      else
         for i = 1, BINT_SIZE do
            self[i] = 0
         end
      end
      return self
   end


   function bint:_inc()
      for i = 1, BINT_SIZE do
         local tmp = self[i]
         local v = (tmp + 1) & BINT_WORDMAX
         self[i] = v
         if v > tmp then
            break
         end
      end
      return self
   end



   function bint.inc(x)
      local ix = bint_assert_convert(x)
      return ix:_inc()
   end


   function bint:_dec()
      for i = 1, BINT_SIZE do
         local tmp = self[i]
         local v = (tmp - 1) & BINT_WORDMAX
         self[i] = v
         if v <= tmp then
            break
         end
      end
      return self
   end



   function bint.dec(x)
      local ix = bint_assert_convert(x)
      return ix:_dec()
   end




   function bint:_assign(y)
      y = bint_assert_convert(y)
      for i = 1, BINT_SIZE do
         self[i] = y[i]
      end
      return self
   end


   function bint:_abs()
      if self:isneg() then
         self:_unm()
      end
      return self
   end



   function bint.abs(x)
      local ix = bint_assert_convert_clone(x)
      return ix:_abs()
   end
   local bint_abs = bint.abs



   function bint.floor(x)
      return bint_assert_convert_clone(x)
   end



   function bint.ceil(x)
      return bint_assert_convert_clone(x)
   end




   function bint.bwrap(x, y)
      x = bint_assert_convert(x)
      if y <= 0 then
         return bint_zero()
      elseif y < BINT_BITS then
         local tmp = (bint_one() << y)
         local tmp2 = tmp:_dec():tointeger()
         return x & tmp2
      end
      return bint_new(x)
   end




   function bint.brol(x, y)
      x, y = bint_assert_convert(x), bint_assert_tointeger(y)
      if y > 0 then
         return (x << y) | (x >> (BINT_BITS - y))
      elseif y < 0 then
         if y ~= math_mininteger then
            return x:bror(-y)
         else
            x:bror(-(y + 1))
            x:bror(1)
         end
      end
      return x
   end




   function bint.bror(x, y)
      x, y = bint_assert_convert(x), bint_assert_tointeger(y)
      if y > 0 then
         return (x >> y) | (x << (BINT_BITS - y))
      elseif y < 0 then
         if y ~= math_mininteger then
            return x:brol(-y)
         else
            x:brol(-(y + 1))
            x:brol(1)
         end
      end
      return x
   end





   function bint.max(x, y)
      local ix = bint_assert_convert(x)
      local iy = bint_assert_convert(y)
      return bint_new(ix:gt(iy) and ix or iy)
   end





   function bint.min(x, y)
      local ix = bint_assert_convert(x)
      local iy = bint_assert_convert(y)
      return bint_new(ix:lt(iy) and ix or iy)
   end




   function bint:_add(y)
      y = bint_assert_convert(y)
      local carry = 0
      for i = 1, BINT_SIZE do
         local tmp = self[i] + y[i] + carry
         carry = tmp >> BINT_WORDBITS
         self[i] = tmp & BINT_WORDMAX
      end
      return self
   end




   function bint.__add(x, y)
      local ix = bint_assert_convert(x)
      local iy = bint_assert_convert(y)
      local z = setmetatable({}, bint)
      local carry = 0
      for i = 1, BINT_SIZE do
         local tmp = ix[i] + iy[i] + carry
         carry = tmp >> BINT_WORDBITS
         z[i] = tmp & BINT_WORDMAX
      end
      return z
   end




   function bint:_sub(y)
      y = bint_assert_convert(y)
      local borrow = 0
      local wordmaxp1 = BINT_WORDMAX + 1
      for i = 1, BINT_SIZE do
         local res = self[i] + wordmaxp1 - y[i] - borrow
         self[i] = res & BINT_WORDMAX
         borrow = (res >> BINT_WORDBITS) ~ 1
      end
      return self
   end




   function bint.__sub(x, y)
      local ix = bint_assert_convert(x)
      local iy = bint_assert_convert(y)
      local z = setmetatable({}, bint)
      local borrow = 0
      local wordmaxp1 = BINT_WORDMAX + 1
      for i = 1, BINT_SIZE do
         local res = ix[i] + wordmaxp1 - iy[i] - borrow
         z[i] = res & BINT_WORDMAX
         borrow = (res >> BINT_WORDBITS) ~ 1
      end
      return z
   end




   function bint.__mul(x, y)
      local ix = bint_assert_convert(x)
      local iy = bint_assert_convert(y)
      local z = bint_zero()
      local sizep1 = BINT_SIZE + 1
      local s = sizep1
      local e = 0
      for i = 1, BINT_SIZE do
         if ix[i] ~= 0 or iy[i] ~= 0 then
            e = math_max(e, i)
            s = math_min(s, i)
         end
      end
      for i = s, e do
         for j = s, math_min(sizep1 - i, e) do
            local a = ix[i] * iy[j]
            if a ~= 0 then
               local carry = 0
               for k = i + j - 1, BINT_SIZE do
                  local tmp = z[k] + (a & BINT_WORDMAX) + carry
                  carry = tmp >> BINT_WORDBITS
                  z[k] = tmp & BINT_WORDMAX
                  a = a >> BINT_WORDBITS
               end
            end
         end
      end
      return z
   end




   function bint.__eq(x, y)
      bint_assert_convert(x)
      bint_assert_convert(y)
      for i = 1, BINT_SIZE do
         if x[i] ~= y[i] then
            return false
         end
      end
      return true
   end




   function bint.eq(x, y)
      local ix = bint_assert_convert(x)
      local iy = bint_assert_convert(y)
      return ix == iy
   end
   local bint_eq = bint.eq

   local function findleftbit(x)
      for i = BINT_SIZE, 1, -1 do
         local v = x[i]
         if v ~= 0 then
            local j = 0
            repeat
               v = v >> 1
               j = j + 1
            until v == 0
            return (i - 1) * BINT_WORDBITS + j - 1, i
         end
      end
   end


   local function sudivmod(nume, deno)
      local rema
      local carry = 0
      for i = BINT_SIZE, 1, -1 do
         carry = carry | nume[i]
         nume[i] = carry // deno
         rema = carry % deno
         carry = rema << BINT_WORDBITS
      end
      return rema
   end










   function bint.udivmod(x, y)
      local nume = bint_assert_convert_clone(x)
      local deno = bint_assert_convert(y)

      local ishighzero = true
      for i = 2, BINT_SIZE do
         if deno[i] ~= 0 then
            ishighzero = false
            break
         end
      end
      if ishighzero then

         local low = deno[1]
         assert(low ~= 0, 'attempt to divide by zero')
         if low == 1 then

            return nume, bint_zero()
         elseif low <= (BINT_WORDMSB - 1) then

            local rema = sudivmod(nume, low)
            return nume, bint_fromuinteger(rema)
         end
      end
      if nume:ult(deno) then

         return bint_zero(), nume
      end

      local denolbit = findleftbit(deno)
      local numelbit, numesize = findleftbit(nume)
      local bit = numelbit - denolbit
      deno = deno << bit
      local wordmaxp1 = BINT_WORDMAX + 1
      local wordbitsm1 = BINT_WORDBITS - 1
      local denosize = numesize
      local quot = bint_zero()
      while bit >= 0 do

         local le = true
         local size = math_max(numesize, denosize)
         for i = size, 1, -1 do
            local a, b = deno[i], nume[i]
            if a ~= b then
               le = a < b
               break
            end
         end

         if le then

            local borrow = 0
            for i = 1, size do
               local res = nume[i] + wordmaxp1 - deno[i] - borrow
               nume[i] = res & BINT_WORDMAX
               borrow = (res >> BINT_WORDBITS) ~ 1
            end

            local i = (bit // BINT_WORDBITS) + 1
            quot[i] = quot[i] | (1 << (bit % BINT_WORDBITS))
         end

         for i = 1, denosize - 1 do
            deno[i] = ((deno[i] >> 1) | (deno[i + 1] << wordbitsm1)) & BINT_WORDMAX
         end
         local lastdenoword = deno[denosize] >> 1
         deno[denosize] = lastdenoword

         if lastdenoword == 0 then
            while deno[denosize] == 0 do
               denosize = denosize - 1
            end
            if denosize == 0 then
               break
            end
         end

         bit = bit - 1
      end

      return quot, nume
   end
   local bint_udivmod = bint.udivmod







   function bint.udiv(x, y)
      bint_assert_convert(x)
      bint_assert_convert(y)
      return (bint_udivmod(x, y))
   end







   function bint.umod(x, y)
      bint_assert_convert(x)
      bint_assert_convert(y)
      local _, rema = bint_udivmod(x, y)
      return rema
   end
   local bint_umod = bint.umod









   function bint.tdivmod(x, y)
      bint_assert_convert(x)
      bint_assert_convert(y)
      local ax
      local ay
      ax, ay = bint_abs(x), bint_abs(y)

      local ix
      local iy
      ix, iy = tobint(ax), tobint(ay)
      local quot
      local rema
      if ix and iy then
         assert(not (bint_eq(x, BINT_MININTEGER) and bint_isminusone(y)), 'division overflow')
         quot, rema = bint_udivmod(ix, iy)
      else
         quot, rema = ax // ay, ax % ay
      end
      local isxneg
      local isyneg
      isxneg, isyneg = bint_isneg(x), bint_isneg(y)

      if isxneg ~= isyneg then
         quot = -quot
      end
      if isxneg then
         rema = -rema
      end
      return quot, rema
   end
   local bint_tdivmod = bint.tdivmod







   function bint.tdiv(x, y)
      bint_assert_convert(x)
      bint_assert_convert(y)
      return (bint_tdivmod(x, y))
   end








   function bint.tmod(x, y)
      local _, rema = bint_tdivmod(x, y)
      return rema
   end










   function bint.idivmod(x, y)
      local ix = bint_assert_convert(x)
      local iy = bint_assert_convert(y)
      local isnumeneg = ix[BINT_SIZE] & BINT_WORDMSB ~= 0
      local isdenoneg = iy[BINT_SIZE] & BINT_WORDMSB ~= 0
      if isnumeneg then
         ix = -ix
      end
      if isdenoneg then
         iy = -iy
      end
      local quot
      local rema
      quot, rema = bint_udivmod(ix, iy)
      if isnumeneg ~= isdenoneg then
         quot:_unm()

         if not rema:iszero() then
            quot:_dec()

            if isnumeneg and not isdenoneg then
               rema:_unm():_add(y)
            elseif isdenoneg and not isnumeneg then
               rema:_add(y)
            end
         end
      elseif isnumeneg then

         rema:_unm()
      end
      return quot, rema
   end
   local bint_idivmod = bint.idivmod








   function bint.__idiv(x, y)
      local ix = bint_assert_convert(x)
      local iy = bint_assert_convert(y)
      local isnumeneg = ix[BINT_SIZE] & BINT_WORDMSB ~= 0
      local isdenoneg = iy[BINT_SIZE] & BINT_WORDMSB ~= 0
      if isnumeneg then
         ix = -ix
      end
      if isdenoneg then
         iy = -iy
      end
      local quot
      local rema
      quot, rema = bint_udivmod(ix, iy)
      if isnumeneg ~= isdenoneg then
         quot:_unm()

         if not rema:iszero() then
            quot:_dec()
         end
      end
      return quot, rema
   end









   function bint.__mod(x, y)
      local _, rema = bint_idivmod(x, y)
      return rema
   end









   function bint.ipow(x, y)
      local ix = bint_assert_convert(x)
      local iy = bint_assert_convert(y)
      if iy:iszero() then
         return bint_one()
      elseif iy:isone() then
         return bint_new(ix)
      end

      x, y = bint_new(x), bint_new(y)
      local z = bint_one()
      repeat
         if y:iseven() then
            x = x * x
            y:_shrone()
         else
            z = x * z
            x = x * x
            y:_dec():_shrone()
         end
      until y:isone()
      return x * z
   end









   function bint.upowmod(x, y, m)
      local mi = bint_assert_convert(m)
      if mi:isone() then
         return bint_zero()
      end
      local xi = bint_new(x)
      local yi = bint_new(y)
      local z = bint_one()
      xi = bint_umod(xi, mi)
      while not yi:iszero() do
         if yi:isodd() then
            z = bint_umod(z * xi, mi)
         end
         yi:_shrone()
         xi = bint_umod(xi * xi, mi)
      end
      return z
   end







   function bint.__shl(x, y)
      x, y = bint_assert_convert_clone(x), bint_assert_tointeger(y)
      if y == math_mininteger or math_abs(y) >= BINT_BITS then
         return bint_zero()
      end
      if y < 0 then
         return x >> -y
      end
      local nvals = y // BINT_WORDBITS
      if nvals ~= 0 then
         x:_shlwords(nvals)
         y = y - nvals * BINT_WORDBITS
      end
      if y ~= 0 then
         local wordbitsmy = BINT_WORDBITS - y
         for i = BINT_SIZE, 2, -1 do
            x[i] = ((x[i] << y) | (x[i - 1] >> wordbitsmy)) & BINT_WORDMAX
         end
         x[1] = (x[1] << y) & BINT_WORDMAX
      end
      return x
   end






   function bint.__shr(x, y)
      x, y = bint_assert_convert_clone(x), bint_assert_tointeger(y)
      if y == math_mininteger or math_abs(y) >= BINT_BITS then
         return bint_zero()
      end
      if y < 0 then
         return x << -y
      end
      local nvals = y // BINT_WORDBITS
      if nvals ~= 0 then
         x:_shrwords(nvals)
         y = y - nvals * BINT_WORDBITS
      end
      if y ~= 0 then
         local wordbitsmy = BINT_WORDBITS - y
         for i = 1, BINT_SIZE - 1 do
            x[i] = ((x[i] >> y) | (x[i + 1] << wordbitsmy)) & BINT_WORDMAX
         end
         x[BINT_SIZE] = x[BINT_SIZE] >> y
      end
      return x
   end




   function bint:_band(y)
      local yi = bint_assert_convert_from_integer(y)
      for i = 1, BINT_SIZE do
         self[i] = self[i] & yi[i]
      end
      return self
   end





   function bint.__band(x, y)
      return bint_assert_convert_clone(x):_band(y)
   end




   function bint:_bor(y)
      y = bint_assert_convert(y)
      for i = 1, BINT_SIZE do
         self[i] = self[i] | y[i]
      end
      return self
   end





   function bint.__bor(x, y)
      return bint_assert_convert_clone(x):_bor(y)
   end




   function bint:_bxor(y)
      y = bint_assert_convert(y)
      for i = 1, BINT_SIZE do
         self[i] = self[i] ~ y[i]
      end
      return self
   end





   function bint.__bxor(x, y)
      return bint_assert_convert_clone(x):_bxor(y)
   end


   function bint:_bnot()
      for i = 1, BINT_SIZE do
         self[i] = (~self[i]) & BINT_WORDMAX
      end
      return self
   end

   function bint.__bnot(x)
      local y = setmetatable({}, bint)
      for i = 1, BINT_SIZE do
         y[i] = (~x[i]) & BINT_WORDMAX
      end
      return y
   end


   function bint:_unm()
      return self:_bnot():_inc()
   end



   function bint.__unm(x)
      return (~x):_inc()
   end






   function bint.ult(x, y)
      for i = BINT_SIZE, 1, -1 do
         local a = x[i]
         local b = y[i]
         if a ~= b then
            return a < b
         end
      end
      return false
   end






   function bint.ule(x, y)
      x, y = bint_assert_convert(x), bint_assert_convert(y)
      for i = BINT_SIZE, 1, -1 do
         local a = x[i]
         local b = y[i]
         if a ~= b then
            return a < b
         end
      end
      return true
   end





   function bint.lt(x, y)
      local ix = bint_assert_convert(x)
      local iy = bint_assert_convert(y)

      local xneg = ix[BINT_SIZE] & BINT_WORDMSB ~= 0
      local yneg = iy[BINT_SIZE] & BINT_WORDMSB ~= 0
      if xneg == yneg then
         for i = BINT_SIZE, 1, -1 do
            local a = ix[i]
            local b = iy[i]
            if a ~= b then
               return a < b
            end
         end
         return false
      end
      return xneg and not yneg
   end

   function bint:gt(y)
      return not self:eq(y) and not self:lt(y)
   end





   function bint.le(x, y)
      local ix = bint_assert_convert(x)
      local iy = bint_assert_convert(y)
      local xneg = ix[BINT_SIZE] & BINT_WORDMSB ~= 0
      local yneg = iy[BINT_SIZE] & BINT_WORDMSB ~= 0
      if xneg == yneg then
         for i = BINT_SIZE, 1, -1 do
            local a = ix[i]
            local b = iy[i]
            if a ~= b then
               return a < b
            end
         end
         return true
      end
      return xneg and not yneg
   end

   function bint:ge(y)
      return self:eq(y) or self:gt(y)
   end



   function bint:__tostring()
      return self:tobase(10)
   end


   setmetatable(bint, {
      __call = function(_, x)
         return bint_new(x)
      end,
   })

   BINT_MATHMININTEGER, BINT_MATHMAXINTEGER = bint_new(_tl_math_mininteger), bint_new(_tl_math_maxinteger)
   BINT_MININTEGER = bint.mininteger()
   memo[memoindex] = bint

   return bint

end

return newmodule
end
end

do
local _ENV = _ENV
package.preload[ "token.utils.tl-utils" ] = function( ... ) local arg = _G.arg;
local _tl_compat; if (tonumber((_VERSION or ''):match('[%d.]*$')) or 0) < 5.3 then local p, m = pcall(require, 'compat53.module'); if p then _tl_compat = m end end; local ipairs = _tl_compat and _tl_compat.ipairs or ipairs; local pairs = _tl_compat and _tl_compat.pairs or pairs; local table = _tl_compat and _tl_compat.table or table





local function find(predicate, arr)
   for _, value in ipairs(arr) do
      if predicate(value) then
         return value
      end
   end
   return nil
end

local function filter(predicate, arr)
   local result = {}
   for _, value in ipairs(arr) do
      if predicate(value) then
         table.insert(result, value)
      end
   end
   return result
end

local function reduce(reducer, initialValue, arr)
   local result = initialValue
   for i, value in ipairs(arr) do
      result = reducer(result, value, i, arr)
   end
   return result
end


local function map(mapper, arr)
   local result = {}
   for i, value in ipairs(arr) do
      result[i] = mapper(value, i, arr)
   end
   return result
end

local function reverse(arr)
   local result = {}
   for i = #arr, 1, -1 do
      table.insert(result, arr[i])
   end
   return result
end

local function compose(...)
   local funcs = { ... }
   return function(x)
      for i = #funcs, 1, -1 do
         x = funcs[i](x)
      end
      return x
   end
end

local function keys(xs)
   local ks = {}
   for k, _ in pairs(xs) do
      table.insert(ks, k)
   end
   return ks
end

local function values(xs)
   local vs = {}
   for _, v in pairs(xs) do
      table.insert(vs, v)
   end
   return vs
end

local function includes(value, arr)
   for _, v in ipairs(arr) do
      if v == value then
         return true
      end
   end
   return false
end

return {
   find = find,
   filter = filter,
   reduce = reduce,
   map = map,
   reverse = reverse,
   compose = compose,
   values = values,
   keys = keys,
   includes = includes,
}
end
end

local _tl_compat; if (tonumber((_VERSION or ''):match('[%d.]*$')) or 0) < 5.3 then local p, m = pcall(require, 'compat53.module'); if p then _tl_compat = m end end; local assert = _tl_compat and _tl_compat.assert or assert; local pairs = _tl_compat and _tl_compat.pairs or pairs; local string = _tl_compat and _tl_compat.string or string; local bint = require('token.utils.bint')(256)
local rxJson = require('json')
local dummy_package = require('dummy.dummy')
dummy_package.print_dummy(1)


Balance = {}
Address = {}









local utils = {
   add = function(a, b)
      return tostring(bint(a) + bint(b))
   end,
   subtract = function(a, b)
      return tostring(bint(a) - bint(b))
   end,
   toBalanceValue = function(a)
      return tostring(bint(a))
   end,
   toNumber = function(a)
      return tonumber(a)
   end,
}


Variant = "0.0.3"
Denomination = Denomination or "12"
Balances = Balances or { [ao.id] = utils.toBalanceValue(10000 * 10 ^ tonumber(Denomination)) }
TotalSupply = TotalSupply or utils.toBalanceValue(10000 * 10 ^ tonumber(Denomination))
Name = Name or 'Points Coin'
Ticker = Ticker or 'PNTS'
Logo = Logo or 'SBCCXwwecBlDqRLUjb8dYABExTJXLieawf7m2aBJ-KY'


local function infoHandler(msg)
   ao.send({
      Target = msg.From,
      Name = Name,
      Ticker = Ticker,
      Logo = Logo,
      Denomination = Denomination,
   })
end

local function balanceHandler(msg)
   local bal = '0'

   if (msg.Tags.Recipient) then
      if (Balances[msg.Tags.Recipient]) then
         bal = Balances[msg.Tags.Recipient]
      end
   elseif msg.Tags.Target and Balances[msg.Tags.Target] then
      bal = Balances[msg.Tags.Target]
   elseif Balances[msg.From] then
      bal = Balances[msg.From]
   end

   ao.send({
      Target = msg.From,
      Balance = bal,
      Ticker = Ticker,
      Account = msg.Tags.Recipient or msg.From,
      Data = bal,
   })
end

local function balancesHandler(msg)
   ao.send({ Target = msg.From, Data = rxJson.encode(Balances) })
end

local function transferHandler(msg)
   assert(type(msg.Tags.Recipient) == 'string', 'Recipient is required!')
   assert(type(msg.Tags.Quantity) == 'string', 'Quantity is required!')
   assert(bint(msg.Tags.Quantity):ge(bint(0)), 'Quantity must be greater than 0')

   if not Balances[msg.From] then Balances[msg.From] = "0" end
   if not Balances[msg.Tags.Recipient] then Balances[msg.Tags.Recipient] = "0" end

   if bint(msg.Tags.Quantity):lt(bint(Balances[msg.From])) then
      Balances[msg.From] = utils.subtract(Balances[msg.From], msg.Tags.Quantity)
      Balances[msg.Tags.Recipient] = utils.add(Balances[msg.Tags.Recipient], msg.Tags.Quantity)

      if not msg.Tags.Cast then
         local debitNotice = {
            Target = msg.From,
            Action = 'Debit-Notice',
            Recipient = msg.Tags.Recipient,
            Quantity = msg.Tags.Quantity,
            Data = Colors.gray ..
            "You transferred " ..
            Colors.blue .. msg.Tags.Quantity .. Colors.gray .. " to " .. Colors.green .. msg.Tags.Recipient .. Colors.reset,
         }
         local creditNotice = {
            Target = msg.Tags.Recipient,
            Action = 'Credit-Notice',
            Sender = msg.From,
            Quantity = msg.Tags.Quantity,
            Data = Colors.gray ..
            "You received " ..
            Colors.blue .. msg.Tags.Quantity .. Colors.gray .. " from " .. Colors.green .. msg.From .. Colors.reset,
         }

         for tagName, tagValue in pairs(msg.Tags) do
            if string.sub(tagName, 1, 2) == "X-" then
               debitNotice[tagName] = tagValue
               creditNotice[tagName] = tagValue
            end
         end

         ao.send(debitNotice)
         ao.send(creditNotice)
      end
   else
      ao.send({
         Target = msg.From,
         Action = 'Transfer-Error',
         ['Message-Id'] = msg.Tags.Id,
         Error = 'Insufficient Balance!',
      })
   end
end

local function mintHandler(msg)
   assert(type(msg.Tags.Quantity) == 'string', 'Quantity is required!')
   assert(bint(msg.Tags.Quantity):ge(bint(0)), 'Quantity must be greater than zero!')

   if not Balances[ao.id] then Balances[ao.id] = "0" end

   if msg.From == ao.id then
      Balances[msg.From] = utils.add(Balances[msg.From], msg.Tags.Quantity)
      TotalSupply = utils.add(TotalSupply, msg.Tags.Quantity)
      ao.send({
         Target = msg.From,
         Data = Colors.gray .. "Successfully minted " .. Colors.blue .. msg.Tags.Quantity .. Colors.reset,
      })
   else
      ao.send({
         Target = msg.From,
         Action = 'Mint-Error',
         ['Message-Id'] = msg.Tags.Id,
         Error = 'Only the Process Id can mint new ' .. Ticker .. ' tokens!',
      })
   end
end


local function totalSupplyHandler(msg)
   assert(msg.From ~= ao.id, 'Cannot call Total-Supply from the same process!')

   ao.send({
      Target = msg.From,
      Action = 'Total-Supply',
      Data = TotalSupply,
      Ticker = Ticker,
   })
end

local function burnHandler(msg)
   assert(type(msg.Tags.Quantity) == 'string', 'Quantity is required!')
   assert(bint(msg.Tags.Quantity):lt(bint(Balances[msg.From])), 'Quantity must be less than or equal to the current balance!')

   Balances[msg.From] = utils.subtract(Balances[msg.From], msg.Tags.Quantity)
   TotalSupply = utils.subtract(TotalSupply, msg.Tags.Quantity)

   ao.send({
      Target = msg.From,
      Data = Colors.gray .. "Successfully burned " .. Colors.blue .. msg.Tags.Quantity .. Colors.reset,
   })
end


Handlers.add('info', Handlers.utils.hasMatchingTag('Action', 'Info'), infoHandler)
Handlers.add('balance', Handlers.utils.hasMatchingTag('Action', 'Balance'), balanceHandler)
Handlers.add('balances', Handlers.utils.hasMatchingTag('Action', 'Balances'), balancesHandler)
Handlers.add('transfer', Handlers.utils.hasMatchingTag('Action', 'Transfer'), transferHandler)
Handlers.add('mint', Handlers.utils.hasMatchingTag('Action', 'Mint'), mintHandler)
Handlers.add('totalSupply', Handlers.utils.hasMatchingTag('Action', 'Total-Supply'), totalSupplyHandler)
Handlers.add('burn', Handlers.utils.hasMatchingTag('Action', 'Burn'), burnHandler)
