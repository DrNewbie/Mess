local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

core:module('CoreElementArea')

local table_insert = table.insert
local table_delete = table.delete
local table_remove = table.remove
local table_icontains = table.icontains

if Global.game_settings and Global.game_settings.level_id == 'arena' then
	local id2seg = {
		[143558] = 89,
		[143608] = 74,
		[143808] = 12,
		[143858] = 93,
		[143908] = 95,
		[135708] = 82
	}
	local fs_original_elementareatrigger_init = ElementAreaTrigger.init
	function ElementAreaTrigger:init(...)
		fs_original_elementareatrigger_init(self, ...)
		local navseg = id2seg[self._id]
		if navseg then
			self._shapes[1]._navseg = navseg
		end
	end
end

ElementAreaTrigger.fs_is_inside = ElementAreaTrigger._is_inside

function ElementAreaTrigger:_is_inside_shape_elements(pos)
	for _, element in ipairs(self._shape_elements) do
		if element:enabled() and element:is_inside(pos) then
			return true
		end
	end
	return false
end

function ElementAreaTrigger:_is_inside_shape_elements_with_disabled(pos)
	for _, element in ipairs(self._shape_elements) do
		if element:is_inside(pos) then
			return true
		end
	end
	return false
end

local function _shapes_have_same_navseg(shapes)
	local navseg = shapes[1]._navseg
	for _, shape in ipairs(shapes) do
		if navseg ~= shape._navseg then
			return nil
		end
	end
	return navseg
end

function ElementAreaTrigger:rebuild_function_is_inside()
	if #self._shapes > 0 and #self._shape_elements > 0 then
		return self._is_inside

	elseif #self._shapes > 0 then
		self.restrict_to_navseg = _shapes_have_same_navseg(self._shapes)
		return self.is_inside

	elseif #self._shape_elements > 0 then
		if self._values.use_disabled_shapes then
			return self._is_inside_shape_elements_with_disabled
		else
			return self._is_inside_shape_elements
		end

	else
		return function() return false end
	end
end

function ElementAreaTrigger:_add_shape(shape)
	table_insert(self._shapes, shape)
	self.fs_is_inside = self:rebuild_function_is_inside()
end

local fs_original_elementareatrigger_onscriptactivated = ElementAreaTrigger.on_script_activated
function ElementAreaTrigger:on_script_activated()
	fs_original_elementareatrigger_onscriptactivated(self)
	self.fs_is_inside = self:rebuild_function_is_inside()
end

function ElementAreaTrigger:operation_set_use_disabled_shapes(use_disabled_shapes)
	self._values.use_disabled_shapes = use_disabled_shapes
	self.fs_is_inside = self:rebuild_function_is_inside()
end

local tmp_vec1 = Vector3()
function ElementAreaTrigger:_should_trigger(unit)
	local values = self._values
	if unit then
		local inside
		local u_mov = unit:movement()
		if u_mov then
			inside = self:fs_is_inside(u_mov:m_pos())
		else
			unit:m_position(tmp_vec1)
			inside = self:fs_is_inside(tmp_vec1)
		end

		local trigger_on = values.trigger_on
		local self_inside = self._inside
		local was_inside = self_inside[1] and table_icontains(self_inside, unit)
		if inside then
			if self:_check_instigator_rules(unit) then
				if not was_inside then
					table_insert(self_inside, unit)
					if trigger_on == 'on_enter' or trigger_on == 'both' then
						return true
					end
				end
				if trigger_on == 'while_inside' then
					return true
				end
			else
				if was_inside then
					table_delete(self_inside, unit)
					if trigger_on == 'on_exit' or trigger_on == 'both' then
						return true
					end
				end
			end
		elseif was_inside then
			table_delete(self_inside, unit)
			if trigger_on == 'on_exit' or trigger_on == 'both' then
				return true
			end
		end
	end
	if values.amount == 'all' then
		local project_amount_all = self:project_amount_all()
		if project_amount_all ~= self._last_project_amount_all then
			self._last_project_amount_all = project_amount_all
			self:_clean_destroyed_units()
			return true
		end
	end
	return false
end

function ElementAreaTrigger:instigators()
	local values = self._values
	if values.unit_ids then
		local instigators = {}
		if Network:is_server() then
			for _, id in ipairs(values.unit_ids) do
				local unit = managers.worlddefinition:get_unit(id)
				if alive(unit) then
					instigators[#instigators + 1] = unit
				end
			end
		end
		return instigators
	end

	local instigator = values.instigator
	local pic = managers.mission.project_instigators_cache
	local cache_key = instigator .. tostring(self._values.restrict_to_navseg)
	local instigators = pic[cache_key]
	if not instigators then
		instigators = self:project_instigators()
		pic[cache_key] = instigators
	end
	if values.spawn_unit_elements[1] then
		pic[cache_key] = nil
		for _, id in ipairs(values.spawn_unit_elements) do
			local element = self:get_mission_element(id)
			if element then
				for _, unit in ipairs(element:units()) do
					if alive(unit) then
						instigators[#instigators + 1] = unit
					end
				end
			end
		end
	end
	return instigators
end

function ElementAreaTrigger:update_area()
	local values = self._values
	if not values.enabled then
		return
	end

	if Network:is_server() then
		local trigger_on = values.trigger_on
		if trigger_on == 'on_empty' then
			values.restrict_to_navseg = nil
			self._inside = {}
			for _, unit in ipairs(self:instigators()) do
				self:_should_trigger(unit)
			end
			if self._inside[1] == nil then
				self:on_executed()
			end

		elseif values.instigator == 'player' and self.restrict_to_navseg then
			local managers = managers
			local unit = managers.player:player_unit()
			if alive(unit) then
				local in_zone = managers.navigation:get_nav_seg_from_pos(unit:position(), true) == self.restrict_to_navseg
				if in_zone and self:_should_trigger(unit) then
					self:_check_amount(unit)
				end
				if not in_zone and self._inside[1] then
					local index = table.get_vector_index(self._inside, unit)
					if index then
						table_remove(self._inside, index)
						if trigger_on == 'on_exit' or trigger_on == 'both' then
							self:_check_amount(unit)
						end
					end
				end
			end

		elseif values.instigator == 'enemies' and self.restrict_to_navseg then
			values.restrict_to_navseg = self.restrict_to_navseg
			local instigators = self:instigators()
			local in_zone = {}
			for _, unit in ipairs(instigators) do
				in_zone[unit:key()] = true
				if self:_should_trigger(unit) then
					self:_check_amount(unit)
				end
			end
			for i = #self._inside, 1, -1 do
				local unit = self._inside[i]
				if not in_zone[unit:key()] then
					table_remove(self._inside, i)
					if trigger_on == 'on_exit' or trigger_on == 'both' then
						self:_check_amount(unit)
					end
				end
			end

		else
			local instigators = self:instigators()
			if instigators[1] == nil then
				if self:_should_trigger(nil) then
					self:_check_amount(nil)
				end
			else
				for _, unit in ipairs(instigators) do
					if self:_should_trigger(unit) then
						self:_check_amount(unit)
					end
				end
			end
		end

	else
		if values.trigger_on ~= 'on_empty' then
			for _, unit in ipairs(self:instigators()) do
				self:_client_check_state(unit)
			end
		end
	end
end

function ElementAreaReportTrigger:update_area()
	if not self._values.enabled then
		return
	end
	local instigators = self:instigators()
	if Network:is_server() then
		if instigators[1] == nil then
			self:_check_state(nil)
		else
			for _, unit in ipairs(instigators) do
				self:_check_state(unit)
			end
		end
	else
		for _, unit in ipairs(instigators) do
			self:_client_check_state(unit)
		end
	end
end

function ElementAreaReportTrigger:_check_state(unit)
	self:_clean_destroyed_units()

	if unit then
		local inside
		local u_mov = unit:movement()
		if u_mov then
			inside = self:fs_is_inside(u_mov:m_pos())
		else
			unit:m_position(tmp_vec1)
			inside = self:fs_is_inside(tmp_vec1)
		end

		if inside then
			if self:_check_instigator_rules(unit) then
				if table_icontains(self._inside, unit) then
					self:_while_inside(unit)
				else
					self:_add_inside(unit)
				end
			else
				self:_rule_failed(unit)
			end
		elseif table_icontains(self._inside, unit) then
			self:_remove_inside(unit)
		end
	end

	local project_amount_all = self:project_amount_all()
	if project_amount_all ~= self._last_project_amount_all then
		self._last_project_amount_all = project_amount_all
		self:_clean_destroyed_units()
		return true
	end

	return false
end

function ElementAreaReportTrigger:_clean_destroyed_units()
	local _inside = self._inside
	for i = #_inside, 1, -1 do
		local unit = _inside[i]
		if not unit or not unit:alive() then
			self:_remove_inside_by_index(i)
		else
			local ucd = unit:character_damage()
			if ucd and ucd:dead() then
				self:on_executed(unit, 'on_death')
				self:_remove_inside_by_index(i)
			end
		end
	end
end
