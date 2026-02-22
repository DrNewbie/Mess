--[[
	@PlayBONK
	https://discord.com/channels/242285927056015361/368375218403803146/1474917394601214163

]]

local ThisModPath = ModPath

CrewBondUSystem = CrewBondUSystem or {}

pcall(function()
	local criminals_number_map = CrewBondUSystem.__format_two_to_each_other({7, 13, 23, 31})
	for _, __criminals_number in pairs(criminals_number_map) do
		local __data = {
			criminals_number = __criminals_number,
			
			name_id = "crewbond_bond_mod_bond_bad_relationships_name1",
			desc_id = "crewbond_bond_mod_bond_bad_relationships_desc1",
			icon_id = "C_Hector_H_Firestarter_HereComesThePain",
			
			func = function(this_bond_number)
				Hooks:PostHook(PlayerManager, "damage_reduction_skill_multiplier", CrewBondUSystem.__Name("get_hurt:"..json.encode(__criminals_number)), function(self, ...)
					local ans = Hooks:GetReturn()
					
					CrewBondUSystem.__log("bad_relationships", this_bond_number)
					
					if not CrewBondUSystem.__is_bond_activing(this_bond_number) then
						return ans
					end
					
					local this_bond_number_map = CrewBondUSystem.__bond_number_map_table[this_bond_number]
					local ply = self:local_player()				
					local ply_name = CriminalsManager.convert_new_to_old_character_workname(managers.criminals:character_name_by_unit(ply))
					local ply_number = CrewBondUSystem.__criminal_number_table[ply_name]
					if ply_number ~= this_bond_number_map[1] and ply_number ~= this_bond_number_map[2] then
						return ans
					end
					
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
					
					return ans
				end)
				return
			end
		}
		CrewBondUSystem.__add_bond_number(__data)
	end
	return
end)