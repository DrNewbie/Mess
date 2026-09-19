dofile("mods/Armor Skins Boosts/Load.lua")

Hooks:Add("LocalizationManagerPostInit", "ArmorBoosts_loc", function(loc)
	local _INFO = {
		["armor_skins_boost_dodge"] = "- Dodge +%s%%",
		["armor_skins_boost_concealment"] = "- Concealment +%s",
		["armor_skins_boost_movement"] = "- Movement +%s%%",
		["armor_skins_boost_armor"] = "- Armor +%s",
		["armor_skins_boost_stamina"] = "- Stamina +%s%%",
		["armor_skins_boost_damage_shake"] = "- Shake +%s%%",
		["armor_skins_boost_armor_regen"] = "- Armor Regen +%s%%"
	}
	local _DESC_VAULE_FIX = {
		dodge = 100,
		concealment = 100,
		movement = 100,
		armor = 100,
		stamina = 100,
		damage_shake = 100,
		armor_regen = 100
	}
	for skins_name, skins_datas in pairs(tweak_data.economy.armor_skins) do
		if skins_datas and skins_datas.body_armor then
			local _desc_data = loc:text(skins_datas.desc_id)
			for i = 1, 7 do
				_desc_data = _desc_data .. "\n(".. loc:text("bm_armor_level_" .. i) ..")" 
				for mod_name, mod_data in pairs(skins_datas.body_armor) do
					if skins_datas.body_armor[mod_name] then
						_desc_data = _desc_data .. " - " ..string.format(tostring(_INFO["armor_skins_boost_" .. mod_name]), tostring(math.round(mod_data["level_" .. i]*(_DESC_VAULE_FIX[mod_name] or 1))))
					end
				end
				_desc_data = _desc_data .. "\n"
			end
			loc:add_localized_strings({
				[skins_datas.desc_id] = _desc_data
			})
		end
	end
end)