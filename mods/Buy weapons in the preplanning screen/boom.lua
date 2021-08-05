local ThisModPath = ModPath
local ThisModIds = Idstring(ThisModPath):key()
local hook1 = "F_"..Idstring("hook1::"..ThisModIds):key()

Hooks:PostHook(NewLoadoutTab, "populate_category", hook1, function(self, data)
	for __k, __v in pairs(data) do
		if type(__v) == "table" and data[__k].unlocked then
			if data[__k].is_loadout and data[__k].empty_slot then
				table.insert(data[__k], "ew_buy")
			else
				--table.insert(data[__k], "w_mod")
				table.insert(data[__k], "w_sell")
			end
		end
	end
end)