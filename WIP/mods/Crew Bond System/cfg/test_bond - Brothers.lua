--[[
	@UnintelligibleYT
	https://www.youtube.com/watch?v=t0DQC34h3eg&lc=UgzKCrh5HZoIAwOf38p4AaABAg

]]

CrewBondUSystem = CrewBondUSystem or {}

CrewBondUSystem.__add_bond_number({
	criminals_number = {2, 7},
	
	name_id = "crewbond_bond_mod_bond_brothers_name1",
	desc_id = "crewbond_bond_mod_bond_brothers_desc1",
	icon_id = "C_Elephant_H_BigOil_DoctorFantastic",
	
	func = function(this_bond_number)
		local faster_ratio = 0.25
		local this_bond_number_number = tonumber(this_bond_number)
	
		Hooks:PostHook(PlayerStandard, "_get_interaction_speed", CrewBondUSystem.__Name("faster helping"), function(self, ...)
			local ans = Hooks:GetReturn()
			
			if not CrewBondUSystem.__is_bond_activing(this_bond_number) then
				return ans
			end
			
			if not self._interact_params or not alive(self._interact_params.object) then 
				return ans
			end
			
			if tostring(self._interact_params.tweak_data) ~= "revive" then
				return ans
			end
			
			local is_okay = false	

			pcall(function()
				if not self._interaction:active_unit() or not alive(self._interaction:active_unit()) then
				
				else
					local __down_criminal_name = tostring(managers.criminals:character_name_by_unit(self._interaction:active_unit()))
					local __down_criminal_number = CrewBondUSystem.__criminal_number_table[__down_criminal_name]
					local __help_criminal_name = tostring(managers.criminals:character_name_by_unit(managers.player:local_player()))
					local __help_criminal_number = CrewBondUSystem.__criminal_number_table[__help_criminal_name]
					if type(__down_criminal_number) == "number" and this_bond_number_number % __down_criminal_number == 0 and 
						type(__help_criminal_number) == "number" and this_bond_number_number % __help_criminal_number == 0 then
						is_okay = true
					end
				end
			end)
			
			if is_okay then
				ans = ans * (1 + faster_ratio)
			end
			
			return ans
		end)
		
		local old_add_delayed_clbk = CopLogicBase.add_delayed_clbk

		function CopLogicBase.add_delayed_clbk(__my_data, __clbk_id, __clbk_func, __t, ...)
			pcall(function()
				if CrewBondUSystem.__is_bond_activing(this_bond_number) and __my_data and __my_data.reviving and alive(__my_data.reviving) and __my_data.unit and alive(__my_data.unit) then
					local __down_criminal_name = tostring(managers.criminals:character_name_by_unit(__my_data.reviving))
					local __down_criminal_number = CrewBondUSystem.__criminal_number_table[__down_criminal_name]
					local __help_criminal_name = tostring(managers.criminals:character_name_by_unit(__my_data.unit))
					local __help_criminal_number = CrewBondUSystem.__criminal_number_table[__help_criminal_name]
					if type(__down_criminal_number) == "number" and this_bond_number_number % __down_criminal_number == 0 and 
						type(__help_criminal_number) == "number" and this_bond_number_number % __help_criminal_number == 0 then
						local this_objective = __my_data.performing_act_objective
						__t = TimerManager:game():time() + (this_objective.action_duration or 0) * (1 - faster_ratio)
					end
				end
			end)
			old_add_delayed_clbk(__my_data, __clbk_id, __clbk_func, __t, ...)
		end
		return
	end
})