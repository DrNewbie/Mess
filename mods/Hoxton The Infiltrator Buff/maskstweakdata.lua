local __ThisModPath = ModPath

Hooks:Add("LocalizationManagerPostInit", "F_"..Idstring("Hooks:Add:LocalizationManagerPostInit:Hoxton The Infiltrator Buff"):key(), function(loc)
	loc:load_localization_file(__ThisModPath.."english.txt")
	local add_buff = {
		loc:text("bm_msk_toon_04_buff_more_hp")
	}
	loc:add_localized_strings({
		["bm_msk_toon_04_desc"] = loc:text("bm_msk_toon_04_desc").."\n\n"..table.concat(add_buff, "\n")
	})
end)