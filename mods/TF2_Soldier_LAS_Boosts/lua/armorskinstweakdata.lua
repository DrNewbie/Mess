LegendaryArmours = LegendaryArmours or {}

Hooks:Add("LocalizationManagerPostInit", "TF2SoldierLASBoosts_loc", function(loc)
	if LegendaryArmours.soldier then
		loc:add_localized_strings({
			["bm_askn_soldier_desc"] = loc:text("bm_askn_soldier_desc").."\n\n".."You can get projectiles from an ammo box now."
		})
	end
	if LegendaryArmours.soldier_blu then
		loc:add_localized_strings({
			["bm_askn_soldier_blu_desc"] = loc:text("bm_askn_soldier_desc").."\n\n".."You can get projectiles from an ammo box now."
		})
	end
end)