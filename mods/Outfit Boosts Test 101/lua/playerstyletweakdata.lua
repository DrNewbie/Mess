Hooks:Add("LocalizationManagerPostInit", "Loc_"..Idstring("Outfit Boosts Test 101"):key(), function(loc)
	loc:add_localized_strings({
		["bm_suit_slaughterhouse_desc"] = loc:text("bm_suit_slaughterhouse_desc").."\n\n".."[+] You gain 10 times more XP from Slaughterhouse Hesit."
	})
end)