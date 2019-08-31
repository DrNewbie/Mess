Hooks:Add("LocalizationManagerPostInit", "AlmirLASBoosts_loc", function(loc)
	if tweak_data.economy.armor_skins.almirsuit then
		loc:add_localized_strings({
			["bm_askn_almirsuit_desc"] = loc:text("bm_askn_almirsuit_desc").."\n\n".."You gain 100x more XP."
		})
	end
	if tweak_data.economy.armor_skins.almirhoodie then
		loc:add_localized_strings({
			["bm_askn_almirhoodie_desc"] = loc:text("bm_askn_almirhoodie_desc").."\n\n".."You gain 100x more XP."
		})
	end
end)