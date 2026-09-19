Hooks:Add("LocalizationManagerPostInit", "Loc_"..Idstring("Glove Boosts Test 101"):key(), function(loc)
	loc:add_localized_strings({
		["bm_gloves_saintsleather_desc"] = loc:text("bm_gloves_saintsleather_desc").."\n\n".."[+] You gain 50% faster reload speed.".."\n",
	})
end)