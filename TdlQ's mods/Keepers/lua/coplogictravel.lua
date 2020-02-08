local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local kpr_original_coplogictravel_enter = CopLogicTravel.enter
function CopLogicTravel.enter(data, new_logic_name, enter_params)
	kpr_original_coplogictravel_enter(data, new_logic_name, enter_params)

	if data.is_converted then
		data.internal_data.itr_direct_to_pos = data.kpr_keep_position
	end
end

local kpr_original_coplogictravel_determinedestinationoccupation = CopLogicTravel._determine_destination_occupation
function CopLogicTravel._determine_destination_occupation(data, objective)
	local occupation

	local keep_position = data.kpr_keep_position
	if keep_position then
		occupation = {type = 'defend', cover = false, pos = keep_position}
	else
		occupation = kpr_original_coplogictravel_determinedestinationoccupation(data, objective)
	end

	return occupation
end

local kpr_original_coplogictravel_getpathingprio = CopLogicTravel.get_pathing_prio
function CopLogicTravel.get_pathing_prio(data)
	local prio = kpr_original_coplogictravel_getpathingprio(data)
	if prio and data.team.id == 'converted_enemy' then
		prio = prio + 1
	end
	return prio
end

local kpr_original_coplogictravel_ondestinationreached = CopLogicTravel._on_destination_reached
function CopLogicTravel._on_destination_reached(data)
	if data.objective.kpr_drop_carry then
		if data.unit:movement().throw_bag then
			data.unit:movement():throw_bag(data.unit)
		end
		data.objective.kpr_drop_carry = nil
	end

	kpr_original_coplogictravel_ondestinationreached(data)
end

local kpr_original_coplogictravel_chkrequestactionwalktoadvancepos = CopLogicTravel._chk_request_action_walk_to_advance_pos
function CopLogicTravel._chk_request_action_walk_to_advance_pos(data, my_data, speed, end_rot, no_strafe, pose, end_pose)
	if data.unit:slot() == 16 then
		local objective = data.unit:brain():objective()
		if not objective then
			-- qued
		elseif objective.type == 'revive' then
			no_strafe = true
		elseif data.unit:movement()._carry_unit then
			-- qued
		elseif objective.pos then
			no_strafe = mvector3.distance(data.unit:position(), objective.pos) > 3000
		elseif objective.type == 'follow' then
			no_strafe = mvector3.distance(data.unit:position(), objective.follow_unit:position()) > 3000
		end
	end

	return kpr_original_coplogictravel_chkrequestactionwalktoadvancepos(data, my_data, speed, end_rot, no_strafe, pose, end_pose)
end
