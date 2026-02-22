--[[
	@PlayBONK
	https://discord.com/channels/242285927056015361/368375218403803146/1474917394601214163

]]

local ThisModPath = ModPath

CrewBondUSystem = CrewBondUSystem or {}

local __data = {
	criminals_number = {7, 13},
	
	name_id = "crewbond_bond_mod_bond_bad_relationships_name1",
	desc_id = "crewbond_bond_mod_bond_bad_relationships_desc1",
	icon_id = "C_Hector_H_Firestarter_HereComesThePain",
	
	func = function(this_bond_number)
		Hooks:PostHook(PlayerManager, "damage_reduction_skill_multiplier", "crewbond_bond_get_hurt_plus50_within_10meters", function(self, ...)
			local ans = Hooks:GetReturn()
			if CrewBondUSystem.__is_bond_activing(this_bond_number) then
				local this_bond_number_map = CrewBondUSystem.__bond_number_map_table[this_bond_number]
				local ply = self:local_player()				
				local ply_name = CriminalsManager.convert_new_to_old_character_workname(managers.criminals:character_name_by_unit(ply))
				local ply_number = CrewBondUSystem.__criminal_number_table[ply_name]
				if ply_number == this_bond_number_map[1] or ply_number == this_bond_number_map[2] then
					local __chars = managers.groupai:state():all_char_criminals()
					for _, crim_data in pairs(__chars) do
						local __unit = crim_data.unit
						if __unit and alive(__unit) and __unit ~= ply and mvector3.distance(ply:position(), __unit:position()) <= 1000 then
							local __near_unit_name = CriminalsManager.convert_new_to_old_character_workname(managers.criminals:character_name_by_unit(__unit))
							local __near_unit_number = CrewBondUSystem.__criminal_number_table[__near_unit_name]
							if __near_unit_number == this_bond_number_map[1] or __near_unit_number == this_bond_number_map[2] then
								ans = ans + 0.50 --Get Hurt+50%
							end
						end
					end
				end
			end
			return ans
		end)
		return
	end
}

CrewBondUSystem.__add_bond_number(__data)

__data.criminals_number = {7, 23}
CrewBondUSystem.__add_bond_number(__data)

__data.criminals_number = {7, 31}
CrewBondUSystem.__add_bond_number(__data)

__data.criminals_number = {13, 23}
CrewBondUSystem.__add_bond_number(__data)

__data.criminals_number = {13, 31}
CrewBondUSystem.__add_bond_number(__data)

__data.criminals_number = {23, 31}
CrewBondUSystem.__add_bond_number(__data)

__data = nil