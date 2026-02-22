local ThisModPath = ModPath

CrewBondUSystem = CrewBondUSystem or {}

CrewBondUSystem.__add_bond_number({
	criminals_number = {2, 3, 5, 13},
	
	name_id = "achievement_green_2",
	desc_id = "crewbond_bond_mod_bond_green_2_desc1",
	icon_id = "C_Classics_H_FirstWorldBank_Original",
	
	func = function(this_bond_number)
		Hooks:PostHook(PlayerManager, "health_skill_multiplier", "crewbond_bond_hp_plus25", function(self, ...)
			local ans = Hooks:GetReturn()
			if CrewBondUSystem.__is_bond_activing(this_bond_number) then
				ans = ans + 0.25 --HP+25%
			end
			return ans
		end)
		return
	end
})

