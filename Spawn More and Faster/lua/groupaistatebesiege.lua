function Mod4ModifySomething(_num)
	local _num_f = math.round(_num/2) + 1
	local _num_b = _num + 2

	for special_type, v in pairs(tweak_data.group_ai.special_unit_spawn_limits) do
		tweak_data.group_ai.special_unit_spawn_limits[special_type] = _num + math.clamp(v*_num_b, 4, 999)
	end

	for cat_name, team in pairs(tweak_data.group_ai.enemy_spawn_groups) do
		if team.amount and team.spawn and team.spawn and team.spawn then
			tweak_data.group_ai.enemy_spawn_groups[cat_name].amount[1] = _num + (team.amount[1] or 1)*_num_f
			tweak_data.group_ai.enemy_spawn_groups[cat_name].amount[2] = _num + (team.amount[2] or 1)*_num_f
			for k, _ in pairs(team.spawn) do
				tweak_data.group_ai.enemy_spawn_groups[cat_name].spawn[k].amount_min = _num + (team.spawn[k].amount_min or 1)*_num_f
				tweak_data.group_ai.enemy_spawn_groups[cat_name].spawn[k].amount_max = _num + (team.spawn[k].amount_max or 1)*_num_f
			end
		end	
	end

	tweak_data.group_ai.phalanx.spawn_chance.respawn_delay = 30
end

Mod4ModifySomething(4)

Hooks:PostHook(GroupAIStateBesiege, "_upd_assault_task", "SMF_GUI_upd_assault_task", function(self, ...)
	local task_data = self._task_data.assault
	if not task_data.active then
		return
	end
	local t = self._t
	if task_data.phase == "anticipation" or task_data.phase == "build" or task_data.phase == "sustain" then
		self:set_wave_mode("assault")
	end
end)

Hooks:PreHook(GroupAIStateBesiege, "_spawn_in_group", "SMF_GUI_spawn_in_group", function(self, ...)
	self._spawning_groups = self._spawning_groups or {}
	local _self_t = self._t or 0
	for k, _ in pairs(self._spawning_groups) do
		local spawn_task = self._spawning_groups[k]
		if spawn_task and spawn_task.spawn_group and spawn_task.spawn_group.spawn_pts then
			local spawn_points = spawn_task.spawn_group.spawn_pts
			if type(spawn_points) == "table" then
				for sp_key, sp_data in ipairs(spawn_points) do
					if not self._spawning_groups[k].spawn_group.spawn_pts[sp_key].mod_delay_t then
						self._spawning_groups[k].spawn_group.spawn_pts[sp_key].mod_delay_t = true
						self._spawning_groups[k].spawn_group.spawn_pts[sp_key].delay_t = _self_t + 0.1
					end
				end
			end
		end
	end
end)

Hooks:PreHook(GroupAIStateBesiege, "_upd_group_spawning", "SMF_GUI_upd_group_spawning", function(self, ...)
	self._spawning_groups = self._spawning_groups or {}
	local _self_t = self._t or 0
	for k, _ in pairs(self._spawning_groups) do
		local spawn_task = self._spawning_groups[k]
		if spawn_task and spawn_task.spawn_group and spawn_task.spawn_group.spawn_pts then
			local spawn_points = spawn_task.spawn_group.spawn_pts
			if type(spawn_points) == "table" then
				for sp_key, sp_data in ipairs(spawn_points) do
					if not self._spawning_groups[k].spawn_group.spawn_pts[sp_key].mod_delay_t then
						self._spawning_groups[k].spawn_group.spawn_pts[sp_key].mod_delay_t = true
						self._spawning_groups[k].spawn_group.spawn_pts[sp_key].delay_t = _self_t + 0.1
					end
				end
			end
		end
	end
end)

Hooks:PreHook(GroupAIStateBesiege, "_begin_new_tasks", "SMF_GUI_begin_new_tasks", function(self, ...)
	local all_areas = self._area_data
	if all_areas then
		local _self_t = self._t or 0
		for area_id, area in pairs(all_areas) do
			if area.spawn_points then
				for sp_key, sp_data in pairs(area.spawn_points) do
					if not self._area_data[area_id].spawn_points[sp_key].mod_delay_t then
						self._area_data[area_id].spawn_points[sp_key].mod_delay_t = true
						self._area_data[area_id].spawn_points[sp_key].delay_t = _self_t + 0.1
					end
				end
			end
		end
	end
end)