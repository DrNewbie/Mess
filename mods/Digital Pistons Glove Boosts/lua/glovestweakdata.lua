Hooks:Add("LocalizationManagerPostInit", "Loc_"..Idstring("Digital Pistons Glove Boosts"):key(), function(loc)
	loc:add_localized_strings({
		["bm_gloves_overkillpunk_desc"] = loc:text("bm_gloves_overkillpunk_desc").."\n\n".."When combined with "..loc:text("bm_melee_fists").." and "..loc:text("bm_melee_fight")..":\n[+] 1000% fists damage.\n[+] Electrocutes and interrupts targets on hit.".."\n",
	})
end)