local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

if Monkeepers.disabled then
	return
end

function TeamAILogicIdle.action_complete_clbk(data, action)
	local my_data = data.internal_data
	local action_type = action:type()

	if action_type == "turn" then
		data.internal_data.turning = nil

		if my_data._turning_to_intimidate then
			my_data._turning_to_intimidate = nil
			TeamAILogicIdle.intimidate_civilians(data, data.unit, true, true, my_data._primary_intimidation_target)
			my_data._primary_intimidation_target = nil
		end

	elseif action_type == "act" then
		my_data.acting = nil
		if my_data.scan and not my_data.exiting and (not my_data.queued_tasks or not my_data.queued_tasks[my_data.wall_stare_task_key]) and not my_data.stare_path_pos then
			my_data.wall_stare_task_key = "CopLogicIdle._chk_stare_into_wall" .. tostring(data.key)
			CopLogicBase.queue_task(my_data, my_data.wall_stare_task_key, CopLogicIdle._chk_stare_into_wall_1, data, data.t)
		end

		if my_data.performing_act_objective then
			local old_objective = my_data.performing_act_objective
			my_data.performing_act_objective = nil
			if my_data.delayed_clbks and my_data.delayed_clbks[my_data.revive_complete_clbk_id] then
				CopLogicBase.cancel_delayed_clbk(my_data, my_data.revive_complete_clbk_id)
				my_data.revive_complete_clbk_id = nil
				local revive_unit = my_data.reviving
				if revive_unit:interaction() then
					if revive_unit:interaction():active() then
						revive_unit:interaction():interact_interupt(data.unit)
					end
				elseif revive_unit:character_damage():arrested() then
					revive_unit:character_damage():unpause_arrested_timer()
				elseif revive_unit:character_damage():need_revive() then
					revive_unit:character_damage():unpause_downed_timer()
				end
				my_data.reviving = nil
				data.objective_failed_clbk(data.unit, data.objective)
			elseif action:expired() then
				if not my_data.action_timeout_clbk_id then
					data.objective_complete_clbk(data.unit, old_objective)
				end
			elseif not my_data.action_expired then -- this
				data.objective_failed_clbk(data.unit, old_objective)
			end
		end
	end
end
