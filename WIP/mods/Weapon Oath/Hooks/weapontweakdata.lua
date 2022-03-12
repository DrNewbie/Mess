local ThisModPath = ModPath
local ThisModIds = Idstring(ThisModPath):key()
local Hook1 = "F_"..Idstring("WeaponTweakData:init::"..ThisModIds):key()

Hooks:PostHook(WeaponTweakData, "init", Hook1, function(self)
	local __default_links_file = io.open(ThisModPath.."Hooks/gfl_to_pd2_guns_real.json", "r")
	local __default_links = {}
	if __default_links_file then
		__default_links = json.decode(__default_links_file:read("*all"))
		__default_links_file:close()
	end	
	for __id, __data in pairs(self) do
		if __default_links[__id] and type(__data) == "table" and type(__data.categories) == "table" and type(__data.use_data) == "table" then
			if type(self[__id].__oath_data) ~= "table" then
				self[__id].__oath_data = {
					__max_points = 1*200000,
					__oath_link = function(is_click, now_rate)
						if is_click then
							Steam:overlay_activate("url", __default_links[__id])
						end
					end
				}
			end
		end
	end
end)