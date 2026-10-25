--[[
	@vxwolf
	

]]

CrewBondUSystem = CrewBondUSystem or {}

CrewBondUSystem.__add_bond_number({
	criminals_number = {79},
	
	name_id = "crewbond_bond_mod_bond_h3h3_name1",
	desc_id = "crewbond_bond_mod_bond_h3h3_desc1",
	icon_id = "C_Vlad_H_Mallcrasher_Shoot",
	
	func = function(this_bond_number)
		if MoneyManager then
			Hooks:PostHook(MoneyManager, "get_civilian_deduction", CrewBondUSystem.__Name("having hila should make cleaner costs $0"), function(self, ...)
				local ans = Hooks:GetReturn()				
				if managers.groupai and CrewBondUSystem.__is_bond_activing(this_bond_number) then
					local current_criminals = managers.groupai:state():all_char_criminals()
					if managers.criminals and type(current_criminals) == "table" and not table.empty(current_criminals) then
						for _, __data in pairs(current_criminals) do
							if __data.unit and alive(__data.unit) and tostring(managers.criminals:character_name_by_unit(__data.unit)) == "ecp_female" then
								return 0
							end
						end
					end
				end
				return ans
			end)
		end	
		return
	end
})

