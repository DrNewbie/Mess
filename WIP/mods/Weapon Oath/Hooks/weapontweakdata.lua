local ThisModPath = ModPath
local ThisModIds = Idstring(ThisModPath):key()
local Hook1 = "F_"..Idstring("WeaponTweakData:init::"..ThisModIds):key()

Hooks:PostHook(WeaponTweakData, "init", Hook1, function(self)
	for __id, __data in pairs(self) do
		if type(__data) == "table" and type(__data.categories) == "table" and type(__data.use_data) == "table" then
			if type(self[__id].__oath_data) ~= "table" then
				self[__id].__oath_data = {
					__max_points = 1*200000,
					__oath_link = function(is_click, now_rate)
						if is_click then
							Steam:overlay_activate("url", "https://iopwiki.com/wiki/Special:Random")
						end
					end
				}
			end
		end
	end
end)