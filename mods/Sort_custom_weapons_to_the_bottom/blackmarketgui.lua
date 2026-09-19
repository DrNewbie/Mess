local ThisModPath = ModPath or tostring(math.random())
local ThisModIds = Idstring(ThisModPath):key()
local __Name = function(__id)
	return "SORT_"..Idstring(tostring(__id).."::"..ThisModIds):key()
end

Hooks:PreHook(BlackMarketGui, "populate_buy_weapon", __Name("Hook1"), function(self, data)
	local __Priority1 = __Name("Priority")
	local __Index1 = __Name("Index")
	for __key, __data in pairs(data.on_create_data) do
		data.on_create_data[__key][__Priority1] = tweak_data.weapon[__data.weapon_id].custom and 1 or 0
		data.on_create_data[__key][__Index1] = __key
	end
	table.sort(data.on_create_data, function(x, y)
		if x[__Priority1] == y[__Priority1] then
			return x[__Index1] < y[__Index1]
		else
			return x[__Priority1] < y[__Priority1]
		end
	end)
end)