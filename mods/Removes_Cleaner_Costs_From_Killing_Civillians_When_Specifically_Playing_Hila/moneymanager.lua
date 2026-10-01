local ThisModPath = ModPath

local __Name = function(__id)
	return "RRR_"..Idstring(tostring(__id).."::"..ThisModPath):key()
end

if _G[__Name(1)] then
	return
end

_G[__Name(1)] = true

Hooks:PostHook(MoneyManager, "get_civilian_deduction", __Name(999), function(self, ...)
	local ans = Hooks:GetReturn()
	
	if managers.groupai then
		local current_criminals = managers.groupai:state():all_char_criminals()
		if managers.criminals and type(current_criminals) == "table" and not table.empty(current_criminals) then
			for _, __data in pairs(current_criminals) do
				if __data.unit and alive(__data.unit) then
					local this_char_name = tostring(managers.criminals:character_name_by_unit(__data.unit))
					if this_char_name == "ecp_female" then
						return 0
					end
				end
			end
		end
	end
	
	return ans
end)