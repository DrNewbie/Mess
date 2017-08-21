function GroupAIStateBase:_get_balancing_multiplier(balance_multipliers)
	local _num = self:num_alive_criminals() or 4
	local _ans = math.clamp((balance_multipliers[#balance_multipliers])*(1.15 + 0.15*_num), 0.10, 999.00)
	return _ans
end

function GroupAIStateBase:_get_difficulty_dependent_value(tweak_values)
	return math.lerp(tweak_values[self._difficulty_point_index], tweak_values[self._difficulty_point_index + 1], self._difficulty_ramp)
end

Hooks:PostHook(GroupAIStateBase, "update", "SMF_GUI_update", function(self, t,...)
	self._SMF_GUI_dealy_t = self._SMF_GUI_dealy_t or 0
	if t < self._SMF_GUI_dealy_t then
		return
	end
	self._SMF_GUI_dealy_t = t + 5
	self._SMF_GUI_Enemy_Amount = 0
	local _all_enemies = managers.enemy:all_enemies() or {}
	for _, data in pairs(_all_enemies) do
		if not managers.groupai:state():is_enemy_special(data.unit) then
			self._SMF_GUI_Enemy_Amount = self._SMF_GUI_Enemy_Amount + 1
		end
	end
end)

function GroupAIStateBase:_SMF_GUI_Get_Enemy_Amount()
	return self._SMF_GUI_Enemy_Amount or 0
end

function GroupAIStateBase:_get_spawn_unit_name(weights, wanted_access_type)
	local unit_categories = tweak_data.group_ai.unit_categories
	local total_weight = 0
	local candidates = {}
	local candidate_weights = {}
	for cat_name, cat_weights in pairs(weights) do
		local cat_weight = self:_get_difficulty_dependent_value(cat_weights)
		local suitable = cat_weight > 0
		local cat_data = unit_categories[cat_name]
		if suitable and cat_data.max_amount then
			local special_type = cat_data.special_type
			local nr_active = self._special_units[special_type] and table.size(self._special_units[special_type]) or 0
			if nr_active >= tweak_data.group_ai.special_unit_spawn_limits[special_type] then
				suitable = false
			end
		end
		if suitable and cat_data.special_type and not self._special_units[cat_name] then
			local nr_boss_types_present = table.size(self._special_units)
			if nr_boss_types_present >= tweak_data.group_ai.max_nr_simultaneous_boss_types then
				suitable = false
			end
		end
		self._SMF_GUI_Enemy_Amount = self._SMF_GUI_Enemy_Amount or 0
		if self._SMF_GUI_Enemy_Amount > 75 then
			suitable = false
		end
		if suitable and wanted_access_type then
			suitable = false
			for _, available_access_type in ipairs(cat_data.access) do
				if wanted_access_type == available_access_type then
					suitable = true
				else
				end
			end
		end
		if suitable then
			total_weight = total_weight + cat_weight
			table.insert(candidates, cat_name)
			table.insert(candidate_weights, total_weight)
		end
	end
	if total_weight == 0 then
		return
	end
	local lucky_nr = math.random() * total_weight
	local i_candidate = 1
	while lucky_nr > candidate_weights[i_candidate] do
		i_candidate = i_candidate + 1
	end
	local lucky_cat_name = candidates[i_candidate]
	local lucky_unit_names = unit_categories[lucky_cat_name].units
	local spawn_unit_name = lucky_unit_names[math.random(#lucky_unit_names)]
	return spawn_unit_name, lucky_cat_name
end