_G.MutatorBigParty = _G.MutatorBigParty or class(BaseMutator)
MutatorBigParty._type = 'MutatorBigParty'
MutatorBigParty.name_id = 'fs_mutator_bigparty_name'
MutatorBigParty.desc_id = 'fs_mutator_bigparty_desc'
MutatorBigParty.has_options = true
MutatorBigParty.reductions = {money = 0, exp = 0}
MutatorBigParty.categories = {'enemies'}
MutatorBigParty.icon_coords = {6, 1}
MutatorBigParty.incompatiblities = {
	'MutatorRealElastic'
}

table.insert(FullSpeedSwarm.custom_mutators, MutatorBigParty)

function MutatorBigParty:register_values(mutator_manager)
	self:register_value('cops_nr', 200, 'cnr')
end

function MutatorBigParty:get_cops_nr()
	return self:value('cops_nr')
end

function MutatorBigParty:set_cops_nr(item)
	self:set_value('cops_nr', item:value())
end

function MutatorBigParty:min_cops_nr()
	return 150
end

function MutatorBigParty:max_cops_nr()
	return 1000
end

function MutatorBigParty:setup_options_gui(node)
	local params = {
		name = 'cops_nr_slider',
		text_id = 'fs_menu_mutator_cops_nr',
		callback = '_update_mutator_value',
		update_callback = callback(self, self, 'set_cops_nr')
	}

	local data_node = {
		type = 'CoreMenuItemSlider.ItemSlider',
		show_value = true,
		min = self:min_cops_nr(),
		max = self:max_cops_nr(),
		step = 5,
		decimal_count = 0
	}

	local new_item = node:create_item(data_node, params)
	new_item:set_value(self:get_cops_nr())
	node:add_item(new_item)
	self._node = node

	return new_item
end

function MutatorBigParty:values()
	-- ugly way to send nothing to clients
	return {}
end

function MutatorBigParty:reset_to_default()
	self:clear_values()

	if self._node then
		local slider = self._node:item('cops_nr_slider')
		if slider then
			slider:set_value(self:get_cops_nr())
		end
	end
end

function MutatorBigParty:options_fill()
	return self:_get_percentage_fill(self:min_cops_nr(), self:max_cops_nr(), self:get_cops_nr())
end

function MutatorBigParty:setup()
	local cops_nr = self:get_cops_nr()
	local group_ai = tweak_data.group_ai
	local assault = group_ai.besiege.assault

	local ratio = cops_nr / (assault.force[#assault.force] * assault.force_balance_mul[#assault.force_balance_mul])

	for id, group in pairs(group_ai.enemy_spawn_groups) do
		if id ~= 'Phalanx' then
			if group.amount then
				for k, v in pairs(group.amount) do
					group.amount[k] = math.round(v * ratio * 5)
				end
			end
			for _, spawn in pairs(group.spawn or {}) do
				if spawn.amount_max then
					spawn.amount_max = math.round(spawn.amount_max * ratio * 5)
				end
			end
		end
	end

	for i = 1, #assault.force do
		assault.force[i] = cops_nr
	end

	for i = 1, #assault.force_balance_mul do
		assault.force_balance_mul[i] = 1
	end

	for i = 1, #assault.force_pool do
		assault.force_pool[i] = math.round(assault.force_pool[i] * assault.force_pool_balance_mul[#assault.force_pool_balance_mul] * ratio)
	end

	for i = 1, #assault.force_pool_balance_mul do
		assault.force_pool_balance_mul[i] = 1
	end

	GroupAIStateBesiege._MAX_SIMULTANEOUS_SPAWNS = 42
	GroupAIStateBesiege._perform_group_spawning = GroupAIStateBesiege_perform_group_spawning
end

function _G.GroupAIStateBesiege_perform_group_spawning(self, spawn_task, force, use_last)
	local nr_units_spawned = 0
	local produce_data = {
		name = true,
		spawn_ai = {}
	}
	local group_ai_tweak = tweak_data.group_ai
	local spawn_points = spawn_task.spawn_group.spawn_pts

	
	local function _try_spawn_unit(u_type_name, spawn_entry)
		if GroupAIStateBesiege._MAX_SIMULTANEOUS_SPAWNS <= nr_units_spawned and not force then
			return
		end

		local hopeless = true
		local current_unit_type = tweak_data.levels:get_ai_group_type()

		for _, sp_data in ipairs(spawn_points) do
			local category = group_ai_tweak.unit_categories[u_type_name]

			if (sp_data.accessibility == "any" or category.access[sp_data.accessibility]) and (not sp_data.amount or sp_data.amount > 0) and sp_data.mission_element:enabled() then
				hopeless = false

				if sp_data.delay_t < self._t then
					local units = category.unit_types[current_unit_type]
					produce_data.name = units[math.random(#units)]
					produce_data.name = managers.modifiers:modify_value("GroupAIStateBesiege:SpawningUnit", produce_data.name)
					local spawned_unit = sp_data.mission_element:produce(produce_data)
					local u_key = spawned_unit:key()
					local objective = nil

					if spawn_task.objective then
						objective = self.clone_objective(spawn_task.objective)
					else
						objective = spawn_task.group.objective.element:get_random_SO(spawned_unit)

						if not objective then
							spawned_unit:set_slot(0)

							return true
						end

						objective.grp_objective = spawn_task.group.objective
					end

					local u_data = self._police[u_key]

					self:set_enemy_assigned(objective.area, u_key)

					if spawn_entry.tactics then
						u_data.tactics = spawn_entry.tactics
						u_data.tactics_map = {}

						for _, tactic_name in ipairs(u_data.tactics) do
							u_data.tactics_map[tactic_name] = true
						end
					end

					spawned_unit:brain():set_spawn_entry(spawn_entry, u_data.tactics_map)

					u_data.rank = spawn_entry.rank

					self:_add_group_member(spawn_task.group, u_key)

					if spawned_unit:brain():is_available_for_assignment(objective) then
						if objective.element then
							objective.element:clbk_objective_administered(spawned_unit)
						end

						spawned_unit:brain():set_objective(objective)
					else
						spawned_unit:brain():set_followup_objective(objective)
					end

					nr_units_spawned = nr_units_spawned + 1

					if spawn_task.ai_task then
						spawn_task.ai_task.force_spawned = spawn_task.ai_task.force_spawned + 1
						spawned_unit:brain()._logic_data.spawned_in_phase = spawn_task.ai_task.phase
					end

					if sp_data.amount then
						sp_data.amount = sp_data.amount - 1
					end

					return true
				end
			end
		end

		if hopeless then
			return true
		end
	end

	for u_type_name, spawn_info in pairs(spawn_task.units_remaining) do
		if not group_ai_tweak.unit_categories[u_type_name].access.acrobatic then
			for i = spawn_info.amount, 1, -1 do
				local success = _try_spawn_unit(u_type_name, spawn_info.spawn_entry)

				if success then
					spawn_info.amount = spawn_info.amount - 1
				end
			end
		end
	end

	for u_type_name, spawn_info in pairs(spawn_task.units_remaining) do
		for i = spawn_info.amount, 1, -1 do
			local success = _try_spawn_unit(u_type_name, spawn_info.spawn_entry)

			if success then
				spawn_info.amount = spawn_info.amount - 1
			end
		end
	end

	local complete = true

	for u_type_name, spawn_info in pairs(spawn_task.units_remaining) do
		if spawn_info.amount > 0 then
			complete = false

			break
		end
	end

	if complete then
		spawn_task.group.has_spawned = true

		table.remove(self._spawning_groups, use_last and #self._spawning_groups or 1)

		if spawn_task.group.size <= 0 then
			self._groups[spawn_task.group.id] = nil
		end
	end
end
