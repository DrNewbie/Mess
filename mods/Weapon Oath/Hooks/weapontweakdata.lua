local ThisModPath = ModPath
local ThisModIds = Idstring(ThisModPath):key()
local Hook1 = "F_"..Idstring("WeaponTweakData:init::"..ThisModIds):key()

Hooks:PostHook(WeaponTweakData, "init", Hook1, function(self)
	for __id, __data in pairs(self) do
		if type(__data) == "table" and type(__data.categories) == "table" and type(__data.use_data) == "table" then
			self[__id].__oath_data = self[__id].__oath_data or {}
			self[__id].__oath_data.__max_points = self[__id].__oath_data.__max_points or 1*20000
		end
	end
end)