local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local pgt_original_groupaistatebesiege_addtosurrendered = GroupAIStateBesiege.add_to_surrendered
function GroupAIStateBesiege:add_to_surrendered(unit, update)
	if unit:base().pgt_is_being_moved then
		local data = unit:brain()._logic_data
		local task_key = 'CivilianLogicSurrender_queued_update' .. tostring(data.key)
		CopLogicBase.queue_task(data.internal_data, task_key, update, data, self._t + 0.3)
		return
	end

	pgt_original_groupaistatebesiege_addtosurrendered(self, unit, update)
end
