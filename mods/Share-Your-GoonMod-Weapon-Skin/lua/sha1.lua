--
-- SHA-1 secure hash computation, and HMAC-SHA1 signature computation,
-- in pure Lua (tested on Lua 5.1)
--
-- Latest version always at:  http://regex.info/blog/lua/sha1
--
-- Copyright 2009 Jeffrey Friedl
-- jfriedl@yahoo.com
-- http://regex.info/blog/
-- 
--
-- Version 1 [May 28, 2009]
--
--
-- Lua is a pathetic, horrid, turd of a language. Not only doesn't it have
-- bitwise integer operators like OR and AND, it doesn't even have integers
-- (and those, relatively speaking, are its good points). Yet, this
-- implements the SHA-1 digest hash in pure Lua. While coding it, I felt as
-- if I were chiseling NAND gates out of rough blocks of silicon. Those not
-- already familiar with this woeful language may, upon seeing this code,
-- throw up in their own mouth.
--
-- It's not super fast.... a 10k-byte message takes about 2 seconds on a
-- circa-2008 mid-level server, but it should be plenty adequate for short
-- messages, such as is often needed during authentication handshaking.
--
-- Algorithm: http://www.itl.nist.gov/fipspubs/fip180-1.htm
--
-- This file creates four entries in the global namespace:
--
--   local hash_as_hex   = sha1(message)            -- returns a hex string
--   local hash_as_data  = sha1_binary(message)     -- returns raw bytes
--
--   local hmac_as_hex   = hmac_sha1(key, message)        -- hex string
--   local hmac_as_data  = hmac_sha1_binary(key, message) -- raw bytes
--
-- Pass sha1() a string, and it returns a hash as a 40-character hex string.
-- For example, the call
--
--   local hash = sha1 "http://regex.info/blog/"
--
-- puts the 40-character string
--
--   "7f103bf600de51dfe91062300c14738b32725db5"
-- 
-- into the variable 'hash'
--
-- Pass sha1_hmac() a key and a message, and it returns the signature as a
-- 40-byte hex string.
--
--
-- The two "_binary" versions do the same, but return the 20-byte string of raw data
-- that the 40-byte hex strings represent.
--

------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------


--
-- Return a W32 object for the number zero
--
local function ZERO()
   return {
      false, false, false, false,     false, false, false, false, 
      false, false, false, false,     false, false, false, false, 
      false, false, false, false,     false, false, false, false, 
      false, false, false, false,     false, false, false, false, 
   }
end

local hex_to_bits = {
   ["0"] = { false, false, false, false },
   ["1"] = { false, false, false, true  },
   ["2"] = { false, false, true,  false },
   ["3"] = { false, false, true,  true  },

   ["4"] = { false, true,  false, false },
   ["5"] = { false, true,  false, true  },
   ["6"] = { false, true,  true,  false },
   ["7"] = { false, true,  true,  true  },

   ["8"] = { true,  false, false, false },
   ["9"] = { true,  false, false, true  },
   ["A"] = { true,  false, true,  false },
   ["B"] = { true,  false, true,  true  },

   ["C"] = { true,  true,  false, false },
   ["D"] = { true,  true,  false, true  },
   ["E"] = { true,  true,  true,  false },
   ["F"] = { true,  true,  true,  true  },

   ["a"] = { true,  false, true,  false },
   ["b"] = { true,  false, true,  true  },
   ["c"] = { true,  true,  false, false },
   ["d"] = { true,  true,  false, true  },
   ["e"] = { true,  true,  true,  false },
   ["f"] = { true,  true,  true,  true  },
}

--
-- Given a string of 8 hex digits, return a W32 object representing that number
--
local function from_hex(hex)

   assert(type(hex) == 'string')
   assert(hex:match('^[0123456789abcdefABCDEF]+$'))
   assert(#hex == 8)

   local W32 = { }

   for letter in hex:gmatch('.') do
      local b = hex_to_bits[letter]
      assert(b)
      table.insert(W32, 1, b[1])
      table.insert(W32, 1, b[2])
      table.insert(W32, 1, b[3])
      table.insert(W32, 1, b[4])
   end

   return W32
end

local function COPY(old)
   local W32 = { }
   for k,v in pairs(old) do
      W32[k] = v
   end

   return W32
end

local function ADD(first, ...)

   local a = COPY(first)

   local C, b, sum

   for v = 1, select('#', ...) do
      b = select(v, ...)
      C = 0

      for i = 1, #a do
         sum = (a[i] and 1 or 0)
             + (b[i] and 1 or 0)
             + C

         if sum == 0 then
            a[i] = false
            C    = 0
         elseif sum == 1 then
            a[i] = true
            C    = 0
         elseif sum == 2 then
            a[i] = false
            C    = 1
         else
            a[i] = true
            C    = 1
         end
      end
      -- we drop any ending carry

   end

   return a
end

local function XOR(first, ...)

   local a = COPY(first)
   local b
   for v = 1, select('#', ...) do
      b = select(v, ...)
      for i = 1, #a do
         a[i] = a[i] ~= b[i]
      end
   end

   return a

end

local function AND(a, b)

   local c = ZERO()

   for i = 1, #a do
      -- only need to set true bits; other bits remain false
      if  a[i] and b[i] then
         c[i] = true
      end
   end

   return c
end

local function OR(a, b)

   local c = ZERO()

   for i = 1, #a do
      -- only need to set true bits; other bits remain false
      if  a[i] or b[i] then
         c[i] = true
      end
   end

   return c
end

local function OR3(a, b, c)

   local d = ZERO()

   for i = 1, #a do
      -- only need to set true bits; other bits remain false
      if a[i] or b[i] or c[i] then
         d[i] = true
      end
   end

   return d
end

local function NOT(a)

   local b = ZERO()

   for i = 1, #a do
      -- only need to set true bits; other bits remain false
      if not a[i] then
         b[i] = true
      end
   end

   return b
end

local function ROTATE(bits, a)

   local b = COPY(a)

   while bits > 0 do
      bits = bits - 1
      table.insert(b, 1, table.remove(b))
   end

   return b

end


local binary_to_hex = {
   ["0000"] = "0",
   ["0001"] = "1",
   ["0010"] = "2",
   ["0011"] = "3",
   ["0100"] = "4",
   ["0101"] = "5",
   ["0110"] = "6",
   ["0111"] = "7",
   ["1000"] = "8",
   ["1001"] = "9",
   ["1010"] = "a",
   ["1011"] = "b",
   ["1100"] = "c",
   ["1101"] = "d",
   ["1110"] = "e",
   ["1111"] = "f",
}

function asHEX(a)

   local hex = ""
   local i = 1
   while i < #a do
      local binary = (a[i + 3] and '1' or '0')
                     ..
                     (a[i + 2] and '1' or '0')
                     ..
                     (a[i + 1] and '1' or '0')
                     ..
                     (a[i + 0] and '1' or '0')

      hex = binary_to_hex[binary] .. hex

      i = i + 4
   end

   return hex

end

local x67452301 = from_hex("67452301")
local xEFCDAB89 = from_hex("EFCDAB89")
local x98BADCFE = from_hex("98BADCFE")
local x10325476 = from_hex("10325476")
local xC3D2E1F0 = from_hex("C3D2E1F0")

local x5A827999 = from_hex("5A827999")
local x6ED9EBA1 = from_hex("6ED9EBA1")
local x8F1BBCDC = from_hex("8F1BBCDC")
local xCA62C1D6 = from_hex("CA62C1D6")


function sha1(msg)

   assert(type(msg) == 'string')
   assert(#msg < 0x7FFFFFFF) -- have no idea what would happen if it were large

   local H0 = x67452301
   local H1 = xEFCDAB89
   local H2 = x98BADCFE
   local H3 = x10325476
   local H4 = xC3D2E1F0

   local msg_len_in_bits = #msg * 8

   local first_append = string.char(0x80) -- append a '1' bit plus seven '0' bits

   local non_zero_message_bytes = #msg +1 +8 -- the +1 is the appended bit 1, the +8 are for the final appended length
   local current_mod = non_zero_message_bytes % 64
   local second_append = ""
   if current_mod ~= 0 then
      second_append = string.rep(string.char(0), 64 - current_mod)
   end

   -- now to append the length as a 64-bit number.
   local B1, R1 = math.modf(msg_len_in_bits  / 0x01000000)
   local B2, R2 = math.modf( 0x01000000 * R1 / 0x00010000)
   local B3, R3 = math.modf( 0x00010000 * R2 / 0x00000100)
   local B4     =            0x00000100 * R3

   local L64 = string.char( 0) .. string.char( 0) .. string.char( 0) .. string.char( 0) -- high 32 bits
            .. string.char(B1) .. string.char(B2) .. string.char(B3) .. string.char(B4) --  low 32 bits



   msg = msg .. first_append .. second_append .. L64         

   assert(#msg % 64 == 0)

   --local fd = io.open("/tmp/msg", "wb")
   --fd:write(msg)
   --fd:close()

   local chunks = #msg / 64

   local W = { }
   local start, A, B, C, D, E, f, K, TEMP
   local chunk = 0

   while chunk < chunks do
      --
      -- break chunk up into W[0] through W[15]
      --
      start = chunk * 64 + 1
      chunk = chunk + 1

      for t = 0, 15 do
         W[t] = from_hex(string.format("%02x%02x%02x%02x", msg:byte(start, start + 3)))
         start = start + 4
      end

      --
      -- build W[16] through W[79]
      --
      for t = 16, 79 do
         -- For t = 16 to 79 let Wt = S1(Wt-3 XOR Wt-8 XOR Wt-14 XOR Wt-16). 
         W[t] = ROTATE(1, XOR(W[t-3], W[t-8], W[t-14], W[t-16]))
      end

      A = H0
      B = H1
      C = H2
      D = H3
      E = H4

      for t = 0, 79 do
         if t <= 19 then
            -- (B AND C) OR ((NOT B) AND D)
            f = OR(AND(B, C), AND(NOT(B), D))
            K = x5A827999
         elseif t <= 39 then
            -- B XOR C XOR D
            f = XOR(B, C, D)
            K = x6ED9EBA1
         elseif t <= 59 then
            -- (B AND C) OR (B AND D) OR (C AND D
            f = OR3(AND(B, C), AND(B, D), AND(C, D))
            K = x8F1BBCDC
         else
            -- B XOR C XOR D
            f = XOR(B, C, D)
            K = xCA62C1D6
         end

         -- TEMP = S5(A) + ft(B,C,D) + E + Wt + Kt; 
         TEMP = ADD(ROTATE(5, A), f, E, W[t], K)

         --E = D; 　　D = C; 　　　C = S30(B);　　 B = A; 　　A = TEMP;
         E = D
         D = C
         C = ROTATE(30, B)
         B = A
         A = TEMP

         --printf("t = %2d: %s  %s  %s  %s  %s", t, A:HEX(), B:HEX(), C:HEX(), D:HEX(), E:HEX())
      end

      -- Let H0 = H0 + A, H1 = H1 + B, H2 = H2 + C, H3 = H3 + D, H4 = H4 + E. 
      H0 = ADD(H0, A)
      H1 = ADD(H1, B)
      H2 = ADD(H2, C)
      H3 = ADD(H3, D)
      H4 = ADD(H4, E)
   end

   return asHEX(H0) .. asHEX(H1) .. asHEX(H2) .. asHEX(H3) .. asHEX(H4)
end