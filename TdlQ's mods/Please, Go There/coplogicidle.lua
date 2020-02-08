local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local pgt_original_coplogicidle_chkrelocate = CopLogicIdle._chk_relocate
function CopLogicIdle._chk_relocate(data)
	if data.unit:base().pgt_destination then
		return false
	end

	if data.unit:brain():is_hostage() then
		if data.internal_data.advancing and not data.internal_data.advancing:expired() then
			return false
		end
	end

	return pgt_original_coplogicidle_chkrelocate(data)
end
