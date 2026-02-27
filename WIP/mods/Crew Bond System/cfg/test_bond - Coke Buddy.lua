--[[
	@Sopgore8402
	https://discord.com/channels/242285927056015361/368375218403803146/1474914127259631637

]]

local ThisModPath = ModPath

CrewBondUSystem = CrewBondUSystem or {}

CrewBondUSystem.__add_bond_number({
	criminals_number = {43, 59},
	
	name_id = "crewbond_bond_mod_bond_coke_buddy_name1",
	desc_id = "crewbond_bond_mod_bond_coke_buddy_desc1",
	icon_id = "C_Locke_H_BorderCrystals_HeisterCocinero",
	
	func = function(this_bond_number)
		Hooks:PostHook(PlayerManager, "movement_speed_multiplier", "crewbond_bond_speed_plus20", function(self, ...)
			local ans = Hooks:GetReturn()
			if CrewBondUSystem.__is_bond_activing(this_bond_number) and self:is_carrying() then
				local carry_id = tostring( self:current_carry_id() )
				if carry_id == "coke" or carry_id == "coke_light" or carry_id == "coke_pure" or carry_id == "present" or carry_id == "yayo" then
					ans = ans + 0.20 --Speed+20%
				end
			end
			return ans
		end)
		return
	end
})