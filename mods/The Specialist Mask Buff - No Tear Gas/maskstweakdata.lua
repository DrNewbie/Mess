local ThisModPath = ModPath

Hooks:Add("LocalizationManagerPostInit", "F_"..Idstring("The Specialist::No Gas Tear Buff"):key(), function(loc)
	loc:load_localization_file(ThisModPath.."english.txt")
	local add_buff = {
		loc:text("bm_msk_smoker_no_gas_tear_01"),
		loc:text("bm_msk_smoker_stamina_decrease_01")
	}
	loc:add_localized_strings({
		["bm_msk_smoker_desc"] = loc:text("bm_msk_smoker_desc").."\n\n"..table.concat(add_buff, "\n")
	})
end)