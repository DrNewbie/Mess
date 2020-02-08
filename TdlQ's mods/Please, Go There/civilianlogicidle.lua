local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local pgt_original_civilianlogicidle_upddetection = CivilianLogicIdle._upd_detection
function CivilianLogicIdle._upd_detection(data)
	local my_data = data.internal_data

	pgt_original_civilianlogicidle_upddetection(data)

	if my_data == data.internal_data and data.unit:base().pgt_is_being_moved then
		CivilianLogicSurrender.pgt_check_surroundings(data)
	end
end
