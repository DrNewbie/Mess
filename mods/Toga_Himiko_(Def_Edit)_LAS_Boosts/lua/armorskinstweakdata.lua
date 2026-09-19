LegendaryArmours = LegendaryArmours or {}

Hooks:Add("LocalizationManagerPostInit", "F_"..Idstring("Hooks:Add:LocalizationManagerPostInit:Toga Himiko (The Definitive Edition) [LAS] Boosts"):key(), function(loc)
	if LegendaryArmours.gt then
		local add_buff = {
			loc:text("bm_gt_defedit_las_boosts")
		}
		loc:add_localized_strings({
			["bm_askn_gt_desc"] = loc:text("bm_askn_gt_desc").."\n\n"..table.concat(add_buff, "\n"),
			["bm_askn_gt_gear_desc"] = loc:text("bm_askn_gt_gear_desc").."\n\n"..table.concat(add_buff, "\n")
		})
	end
end)