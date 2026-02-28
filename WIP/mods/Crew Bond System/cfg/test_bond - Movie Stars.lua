--[[
	@UnintelligibleYT
	https://www.youtube.com/watch?v=IGkodt4ZbuU&lc=UgwXFxtxli5Utz3Xw-h4AaABAg

]]

CrewBondUSystem = CrewBondUSystem or {}

CrewBondUSystem.__add_bond_number({
	criminals_number = {11, 41, 43, 59},
	
	name_id = "crewbond_bond_mod_bond_movie_stars_name1",
	desc_id = "crewbond_bond_mod_bond_movie_stars_desc1",
	icon_id = "C_Dentist_H_BigBank_AllDiffs_OD_D6",
	
	func = function(this_bond_number)
		if PlayerManager then
			Hooks:PostHook(PlayerManager, "critical_hit_chance", CrewBondUSystem.__Name("movie stars - more critical hit chance"), function(self, ...)
				local ans = Hooks:GetReturn()
				if CrewBondUSystem.__is_bond_activing(this_bond_number) then
					ans = ans + 0.05 --critical hit chance+5%
				end
				return ans
			end)
		end
		if CopDamage then 
			Hooks:PostHook(CopDamage, "roll_critical_hit", CrewBondUSystem.__Name("movie stars - more critical hit damage"), function(self, ...)
				local critical_hit, damage = Hooks:GetReturn()
				if CrewBondUSystem.__is_bond_activing(this_bond_number) then
					damage = damage * 1.15 --critical hit damage+15%
				end
				return critical_hit, damage
			end)
		end
		return
	end
})

