Hooks:Add("LocalizationManagerPostInit", "Loc_"..Idstring("Glove Boosts Test 101"):key(), function(loc)
	loc:add_localized_strings({
		["bm_gloves_molten_desc"] = loc:text("bm_gloves_molten_desc").."\n\n".."[+] 100% fire damage and 2x fire stick time.".."\n",
	})
end)