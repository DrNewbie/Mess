local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local kpr_original_teamailogictravel_enter = TeamAILogicTravel.enter
function TeamAILogicTravel.enter(data, new_logic_name, enter_params)
	kpr_original_teamailogictravel_enter(data, new_logic_name, enter_params)

	if data.objective and data.objective.type ~= 'follow' and data.objective.pos then
		data.internal_data.itr_direct_to_pos = data.objective.pos
	else
		data.internal_data.itr_direct_to_pos = data.kpr_keep_position
	end
end
