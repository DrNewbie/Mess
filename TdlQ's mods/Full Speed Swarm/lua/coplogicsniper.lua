local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local REACT_AIM = AIAttentionObject.REACT_AIM
local REACT_SCARED = AIAttentionObject.REACT_SCARED

function CopLogicSniper._upd_enemy_detection(data)
	managers.groupai:state():on_unit_detection_updated(data.unit)

	data.t = TimerManager:game():time()
	local my_data = data.internal_data
	local min_reaction = REACT_AIM
	local delay = CopLogicBase._upd_attention_obj_detection(data, min_reaction, nil)
	local new_attention, new_prio_slot, new_reaction = CopLogicIdle._get_priority_attention(data, data.detected_attention_objects, CopLogicSniper._chk_reaction_to_attention_object)
	local old_att_obj = data.attention_obj

	CopLogicBase._set_attention_obj(data, new_attention, new_reaction)

	if new_reaction and new_reaction >= REACT_SCARED then
		local objective = data.objective
		local wanted_state
		local allow_trans, obj_failed = CopLogicBase.is_obstructed(data, objective, nil, new_attention)
		if allow_trans and obj_failed then
			wanted_state = CopLogicBase._get_logic_state_from_reaction(data)
		end
		if wanted_state and wanted_state ~= data.name then
			if obj_failed then
				data.objective_failed_clbk(data.unit, data.objective)
			end
			if my_data == data.internal_data then
				CopLogicBase._exit(data.unit, wanted_state)
			end
			CopLogicBase._report_detections(data.detected_attention_objects)
			return
		end
	end

	CopLogicSniper._upd_aim(data, my_data)

	delay = data.important and 0.1 or 0.5 + delay * 1.5

	CopLogicBase.queue_task(my_data, my_data.detection_task_key, CopLogicSniper._upd_enemy_detection, data, data.t + delay)
	CopLogicBase._report_detections(data.detected_attention_objects)
end
