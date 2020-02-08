local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

if not Iter.settings.streamline_path then
	return
end

local itr_original_coplogicidle_performobjectiveaction = CopLogicIdle._perform_objective_action
function CopLogicIdle._perform_objective_action(data, my_data, objective)
	if objective and objective.action and objective.action.variant == 'e_so_ntl_idle_look3' then
		objective.action.variant = 'e_so_ntl_idle_look2'
	end
	itr_original_coplogicidle_performobjectiveaction(data, my_data, objective)
end
