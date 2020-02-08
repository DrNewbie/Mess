local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local itr_original_drill_clbkinvestigatesoverification = Drill.clbk_investigate_SO_verification
function Drill:clbk_investigate_SO_verification(candidate_unit)
	local result = itr_original_drill_clbkinvestigatesoverification(self, candidate_unit)
	if result then
		local brain = candidate_unit:brain()
		local search_params = {
			access_pos = brain._SO_access,
			from_tracker = candidate_unit:movement():nav_tracker(),
			to_seg = managers.navigation:get_nav_seg_from_pos(self._unit:position(), true)
		}
		if not managers.navigation:search_coarse(search_params) then
			return
		end

		brain.itr_fallback_objective_temp = brain:objective()
	end

	return result
end

local itr_original_drill_oninvestigatesoadministered = Drill.on_investigate_SO_administered
function Drill:on_investigate_SO_administered(receiver_unit)
	itr_original_drill_oninvestigatesoadministered(self, receiver_unit)

	local brain = receiver_unit:brain()
	brain.itr_fallback_objective = brain.itr_fallback_objective_temp
	brain.itr_fallback_objective_temp = nil
end

local itr_original_drill_unregisterinvestigateso = Drill._unregister_investigate_SO
function Drill:_unregister_investigate_SO()
	local receiver_unit = self._investigate_SO_data and self._investigate_SO_data.receiver_unit
	local old_obj
	if alive(receiver_unit) then
		old_obj = receiver_unit:brain():objective()
	end

	itr_original_drill_unregisterinvestigateso(self)

	if alive(receiver_unit) then
		local brain = receiver_unit:brain()
		local new_obj
		if old_obj then
			new_obj = old_obj
			new_obj.complete_clbk = nil
			new_obj.fail_clbk = nil
			new_obj.action_start_clbk = nil
			new_obj.followup_objective = brain.itr_fallback_objective
		else
			new_obj = brain.itr_fallback_objective
		end
		brain:set_objective(new_obj)
		brain.itr_fallback_objective = nil
	end
end
