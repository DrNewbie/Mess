local ThisModPath = ModPath

Hooks:Add("LocalizationManagerPostInit", "F_"..Idstring("::::No Gas Tear Buff"):key(), function(loc)
	loc:load_localization_file(ThisModPath.."english.txt")
	local add_buff = {
		loc:text("bm_msk_newfunction_no_gas_tear_01"),
		loc:text("bm_msk_newfunction_stamina_decrease_01")
	}
	loc:add_localized_strings({
		["bm_msk_smoker_desc"] = loc:text("bm_msk_smoker_desc").."\n\n"..table.concat(add_buff, "\n"),
		["bm_msk_jfr_03_desc"] = loc:text("bm_msk_jfr_03_desc").."\n\n"..table.concat(add_buff, "\n"),
		["bm_msk_gasmask_desc"] = loc:text("bm_msk_gasmask_desc").."\n\n"..table.concat(add_buff, "\n")
	})
end)