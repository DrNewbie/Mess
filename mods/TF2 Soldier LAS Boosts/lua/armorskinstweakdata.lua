Hooks:Add("LocalizationManagerPostInit", "TF2SoldierLASBoosts_loc", function(loc)
	if tweak_data.economy.armor_skins.soldier then
		loc:add_localized_strings({
			["bm_askn_soldier_desc"] = loc:text("bm_askn_soldier_desc").."\n\n".."You can get projectiles from an ammo box now."
		})
	end
	if tweak_data.economy.armor_skins.soldier_blu then
		loc:add_localized_strings({
			["bm_askn_soldier_blu_desc"] = loc:text("bm_askn_soldier_desc").."\n\n".."You can get projectiles from an ammo box now."
		})
	end
end)