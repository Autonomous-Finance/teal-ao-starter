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
