Hooks:PostHook(WeaponFactoryTweakData, "create_bonuses", "AkimboWTF_WeaponFactoryTweakData", function(self, tweak_data)
	for id, data in pairs(tweak_data.upgrades.definitions) do
		local weapon_tweak = tweak_data.weapon[data.weapon_id]
		local primary_category = weapon_tweak and weapon_tweak.categories and weapon_tweak.categories[1]
		if data.weapon_id and weapon_tweak and data.factory_id and self[data.factory_id] then
			if primary_category == "akimbo" then
				table.insert(self[data.factory_id].uses_parts, "wpn_fps_akimbo_x100_wtf")
			end
		end
	end
end)