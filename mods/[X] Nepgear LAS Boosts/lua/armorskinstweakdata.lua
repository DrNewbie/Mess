Hooks:Add("LocalizationManagerPostInit", "NepgearLASBoosts_loc", function(loc)
	if tweak_data.economy.armor_skins.nopgrear then
		local add_buff = {
			"[+] When the teammate down, you regenerate 100% health and armor.",
			"[+] Each teammate in custody, you gain 100% more health, armor.",
			"[+] Each teammate in custody, you gain 15% more speed.",
			"[+] You melee charge time reduce 100% and attack speed increase 50%.",
			"[+] The lower health teammate have, the more damage you gain.",
			"[-] Your total ammo capacity is decreased by 100%."
		}
		loc:add_localized_strings({
			["bm_askn_nopgrear_desc"] = loc:text("bm_askn_nopgrear_desc").."\n\n"..table.concat(add_buff, "\n")
		})
	end
end)