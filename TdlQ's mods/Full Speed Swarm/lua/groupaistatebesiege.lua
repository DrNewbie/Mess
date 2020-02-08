local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local fs_settings = FullSpeedSwarm.final_settings

local fs_groupaistatebesiege_spawningroup = GroupAIStateBesiege._spawn_in_group
function GroupAIStateBesiege:_spawn_in_group(spawn_group, spawn_group_type, grp_objective, ai_task)
	grp_objective.fs_task_data = self._task_data
	return fs_groupaistatebesiege_spawningroup(self, spawn_group, spawn_group_type, grp_objective, ai_task)
end

local fs_groupaistatebesiege_createobjectivefromgroupobjective = GroupAIStateBesiege._create_objective_from_group_objective
function GroupAIStateBesiege._create_objective_from_group_objective(grp_objective, receiving_unit)
	local objective = fs_groupaistatebesiege_createobjectivefromgroupobjective(grp_objective, receiving_unit)

	if fs_settings.custom_assault and grp_objective.fs_task_data then
		if grp_objective.type == 'assault_area' then
			local assault_task = grp_objective.fs_task_data.assault
			if assault_task and assault_task.phase and assault_task.phase ~= 'fade' then
				local primary_target_area = assault_task.target_areas and assault_task.target_areas[1]
				if primary_target_area then
					objective.area = primary_target_area
				end
			end
		end
	end

	return objective
end

local fs_groupaistatebesiege_checkphalanxgrouphasspawned = GroupAIStateBesiege._check_phalanx_group_has_spawned
function GroupAIStateBesiege:_check_phalanx_group_has_spawned()
	if self._phalanx_spawn_group and self._phalanx_spawn_group.has_spawned then
		if not self._phalanx_spawn_group.set_to_phalanx_group_obj then
			for i, group_unit in pairs(self._phalanx_spawn_group.units) do
				if not alive(group_unit.unit) then
					if group_unit.tweak_table == 'phalanx_vip' then
						-- because sending the captain right into a killzone is always a good idea...
						managers.groupai:state():phalanx_damage_reduction_disable()
						managers.groupai:state():unregister_phalanx_vip()
						self._phalanx_spawn_group.units[i] = nil
					end
				end
			end
		end
	end

	fs_groupaistatebesiege_checkphalanxgrouphasspawned(self)
end
