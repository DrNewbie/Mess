Hooks:Add("LocalizationManagerPostInit", "AstolfoLASBoosts_loc", function(loc)
	if tweak_data.economy.armor_skins.grandcutie then
		local add_buff = {
			loc:text("bm_askn_grandcutie_boosts_succ")
		}
		loc:add_localized_strings({
			["bm_askn_grandcutie_desc"] = loc:text("bm_askn_grandcutie_desc").."\n\n"..table.concat(add_buff, "\n")
		})
	end
end)