Hooks:Add("LocalizationManagerPostInit", "Loc_"..Idstring("Firescale Glove Boosts"):key(), function(loc)
	loc:add_localized_strings({
		["bm_gloves_dragonscale_desc"] = loc:text("bm_gloves_dragonscale_desc").."\n\n".."When combined with fists:\n[+] 1000% fists damage.\n[+] Burns and interrupts targets on hit.".."\n",
	})
end)