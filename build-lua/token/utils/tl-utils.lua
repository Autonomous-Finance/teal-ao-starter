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
