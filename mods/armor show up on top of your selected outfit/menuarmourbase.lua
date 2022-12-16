local ThisModPath = ModPath
local ThisModIds = Idstring(ThisModPath):key()
local __Name = function(__id)
	return "Armor_"..Idstring(tostring(__id).."::"..ThisModIds):key()
end
local Func1 = __Name("force_apply_armor")

MenuArmourBase[Func1] = MenuArmourBase[Func1] or function(self, ...)
	if not self._unit or not alive(self._unit) or not self._armor_id then
	
	else
		local armor_part = {
			level_2 = {
				"g_vest_small"
			},
			level_3 = {
				"g_vest_body"
			},
			level_4 = {
				"g_vest_body",
				"g_vest_neck"
			},
			level_5 = {
				"g_vest_body",
				"g_vest_shoulder",
				"g_vest_neck"
			},
			level_6 = {
				"g_vest_body",
				"g_vest_shoulder",
				"g_vest_neck",
				"g_vest_thies"
			},
			level_7 = {
				"g_vest_body",
				"g_vest_shoulder",
				"g_vest_neck",
				"g_vest_thies",
				"g_vest_leg_arm"
			}
		}
		local armor_id = self._armor_id
		local armor_data = armor_part[armor_id]
		if armor_data then
			for _, __ids in pairs(armor_data) do
				if self._unit:get_object(Idstring(__ids)) then
					self._unit:get_object(Idstring(__ids)):set_visibility(true)
				end
			end
		end		
	end
end

Hooks:PostHook(MenuArmourBase, "_apply_cosmetics", __Name("_apply_cosmetics"), function(self, ...)
	call_on_next_update(callback(self, self, Func1))
end)

Hooks:PostHook(MenuArmourBase, "update_character_visuals", __Name("update_character_visuals"), function(self, ...)
	call_on_next_update(callback(self, self, Func1))
end)