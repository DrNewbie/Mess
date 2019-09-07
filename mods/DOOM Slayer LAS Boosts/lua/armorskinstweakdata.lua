Hooks:Add("LocalizationManagerPostInit", "DewmSlayaLASBoosts_loc", function(loc)
	if tweak_data.economy.armor_skins.dewmslaya then
		local add_buff = {
			loc:text("bm_askn_dewmslaya_boosts_more_ammo"),
			loc:text("bm_askn_dewmslaya_boosts_more_stamia"),
			loc:text("bm_askn_dewmslaya_boosts_no_reload"),
			--loc:text("bm_askn_dewmslaya_boosts_glory_kills"),
			loc:text("bm_askn_dewmslaya_boosts_chainsaw_reward"),
			loc:text("bm_askn_dewmslaya_boosts_one_life")
		}
		loc:add_localized_strings({
			["bm_askn_dewmslaya_desc"] = loc:text("bm_askn_dewmslaya_desc").."\n\n"..table.concat(add_buff, "\n")
		})
	end
end)