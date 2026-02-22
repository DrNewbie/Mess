local ThisModPath = ModPath
local ThisModIds = Idstring(ThisModPath):key()

local __Name = function(__id)
	return "CW_"..Idstring(tostring(__id).."::"..ThisModIds):key()
end

CrewBondUSystem = CrewBondUSystem or {}

CrewBondUSystem.__bond_number_map_table = CrewBondUSystem.__bond_number_map_table or {}

if _G[__Name(101)] then return end
_G[__Name(101)] = true

local current_criminals = {}
local current_criminals_key = "none"
local last_criminals_key = "nil"

local __delay = 5

Hooks:PostHook(PlayerDamage, "update", __Name(101), function(self, _, _, __dt, ...)
	if __delay <= 0 and self._unit and alive(self._unit) and not self:is_downed() and managers.criminals and managers.groupai then
		__delay = 3
		
		current_criminals = managers.groupai:state():all_char_criminals()
		current_criminals_key = __Name(current_criminals)		
		local __bond_number_map_table = CrewBondUSystem.__bond_number_map_table		
		if last_criminals_key == current_criminals_key or type(__bond_number_map_table) ~= "table" or table.empty(__bond_number_map_table) then
			return
		end		
		last_criminals_key = current_criminals_key
		
		local __criminals_number, __criminals_number_map = CrewBondUSystem.__get_current_criminals_number(current_criminals)
		if type(__criminals_number) ~= "number" or __criminals_number <= 1 or type(__criminals_number_map) ~= "table" or table.empty(__criminals_number_map) then
			return
		end
			
		CrewBondUSystem.__clean_bond_activing()
		
		for __bond_number, __bond_map in pairs(__bond_number_map_table) do
			if __criminals_number == tonumber(__bond_number) then
				CrewBondUSystem.__set_bond_activing(__bond_number, true)
			end
			if not CrewBondUSystem.__is_bond_activing(__bond_number) then
				local __req_match_times = #__bond_map
				for _, __bond_crew_number in pairs(__bond_map) do
					if __criminals_number % __bond_crew_number == 0 then
						__req_match_times = __req_match_times - 1
					end
					if __req_match_times <= 0 then
						break
					end
				end
				if __req_match_times <= 0 then
					CrewBondUSystem.__set_bond_activing(__bond_number, true)
					break
				end
			end
		end
	else
		__delay = __delay - __dt
	end
end)