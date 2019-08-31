Hooks:Add("LocalizationManagerPostInit", "TogaHimikoLASBoosts_loc", function(loc)
	if tweak_data.economy.armor_skins.toga then
		loc:add_localized_strings({
			["bm_askn_toga_desc"] = loc:text("bm_askn_toga_desc").."\n\n".."Increase weapons firing and something else."
		})
	end
end)