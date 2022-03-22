if Network and Network:is_client() then
	return
end

Hooks:PostHook(GroupAITweakData, "_init_unit_categories", "yufuwangrushlol", function(self, ...)
    if Global.game_settings and Global.game_settings.level_id and Global.game_settings.level_id == "pent" then
		for k, v in pairs(self.unit_categories or {}) do
			if v.unit_types and v.unit_types.america and v.unit_types.russia and k ~= "Phalanx_vip" and k ~= "Phalanx_minion" then
				for __type, __data in pairs(self.unit_categories[k].unit_types) do
					table.insert(self.unit_categories[k].unit_types[__type], "units/pd2_dlc_pent/characters/npc_male_yufuwang_armored/npc_male_yufuwang_armored")
				end
			end
		end
	end
end)