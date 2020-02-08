local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

core:module('CoreMissionManager')

local kpr_custom_elements = {}

if Network:is_client() then
	local kpr_original_missionscript_load = MissionScript.load
	function MissionScript:load(data)
		local state = data[self._name]
		if data.keepers then
			for id, element in pairs(data.keepers) do
				state[id] = element
			end
			data.keepers = nil
		end

		kpr_original_missionscript_load(self, data)
	end
else
	local kpr_original_missionscript_save = MissionScript.save
	function MissionScript:save(data)
		kpr_original_missionscript_save(self, data)

		local state = data[self._name]
		local kpr_state = {}
		for _, id in ipairs(kpr_custom_elements) do
			kpr_state[id] = state[id]
			state[id] = nil
		end
		data.keepers = kpr_state
	end
end

local level_id = Global.game_settings and Global.game_settings.level_id or ''
local kpr_original_missionmanager_addscript = MissionManager._add_script
local kpr_original_missionscript_createelements = MissionScript._create_elements

function MissionScript:kpr_is_valid_sequence(element)
	local values = element._values
	if values.trigger_list then
		for _, trigger in ipairs(values.trigger_list) do
			local notif = trigger.notify_unit_sequence
			if notif == 'enable_interaction' or notif == 'interact_enabled' or notif == 'state_interaction_enabled' then
				return trigger.notify_unit_id, values.instance_name
			end
		end
	end
	return false
end

local table_icontains = table.icontains or table.contains
function MissionScript:kpr_find_stuff(element, search_unit_sequence, search_waypoint)
	local waypoint_id, unit_id
	local processed = { [element._id] = true }
	local to_process = {}

	local groups = self:element_groups()
	local group_ElementUnitSequence = groups['ElementUnitSequence'] or {}
	local group_ElementWaypoint = groups['ElementWaypoint'] or {}
	local group_ElementOperator = groups['ElementOperator'] or {}
	local group_MissionScriptElement = groups['MissionScriptElement'] or {}

	for _, child in ipairs(element._values.on_executed) do
		table.insert(to_process, self:element(child.id))
	end
	element = table.remove(to_process)

	while element do
		processed[element._id] = true

		if search_unit_sequence and not unit_id and table_icontains(group_ElementUnitSequence, element) then
			unit_id = self:kpr_is_valid_sequence(element)

		elseif search_waypoint and not waypoint_id and table_icontains(group_ElementWaypoint, element) then
			waypoint_id = element._id

		elseif table_icontains(group_MissionScriptElement, element)
		or table_icontains(group_ElementOperator, element) and element._values.operation == 'none'
		then
			for _, child in ipairs(element._values.on_executed) do
				if not processed[child.id] then
					table.insert(to_process, self:element(child.id))
				end
			end
		end

		element = table.remove(to_process)
	end

	if search_waypoint and not waypoint_id and unit_id then
		for _, element2 in ipairs(groups['ElementUnitSequenceTrigger'] or {}) do
			local sl = element2._values.sequence_list
			if #sl == 1 and sl[1].unit_id == unit_id and sl[1].sequence ~= 'interact' then
				waypoint_id = self:kpr_find_stuff(element2, false, true)
				if waypoint_id then
					break
				end
			end
		end
	end

	return waypoint_id, unit_id
end

function MissionScript:_create_elements(elements)
	local new_elements = kpr_original_missionscript_createelements(self, elements)

	local wp_to_unit_id = _G.Keepers.wp_to_unit_id
	local unitid_to_SO = _G.Keepers.unitid_to_SO

	if self._element_groups.ElementUnitSequence then
		for _, element in ipairs(self._element_groups.ElementUnitSequence) do
			local unit_id, instance_name = self:kpr_is_valid_sequence(element)
			if instance_name then
				wp_to_unit_id[instance_name] = unit_id
			end
		end
	end

	if self._element_groups.ElementSpecialObjectiveTrigger then
		for _, element in ipairs(self._element_groups.ElementSpecialObjectiveTrigger) do
			local instance_name = element._values.instance_name
			if element._values.event == 'complete' then
				if #element._values.elements == 1 then
					if instance_name then
						if wp_to_unit_id[instance_name] then
							unitid_to_SO[instance_name] = element._values.elements[1]
						end
					else
						local waypoint_id, unit_id = self:kpr_find_stuff(element, true, true)
						if unit_id then
							unitid_to_SO[unit_id] = element._values.elements[1]
							if waypoint_id then
								wp_to_unit_id[waypoint_id] = unit_id
							end
						end
					end
				end
			end
		end
	end

	return new_elements
end

if level_id == 'pbr' then

	function MissionManager:_add_script(data)
		for _, element in pairs(data.elements) do
			if element.id == 100968 then
				table.remove(element.values.elements, 4)
			end
		end
		kpr_original_missionmanager_addscript(self, data)
	end

elseif level_id == 'pbr2' then

	function MissionManager:_add_script(data)
		local ref102095, elm101017
		for _, element in pairs(data.elements) do
			if element.id == 101020 then
				element.values.trigger_times = 3
				ref102095 = table.remove(element.values.on_executed, 1)
			elseif element.id == 101017 then
				elm101017 = element
			elseif element.id == 101021 then
				element.values.instigator = 'intimidated_enemies'
				element.values.trigger_times = 8
				table.insert(element.values.on_executed, { delay = 0, id = 102092 })
			elseif element.id == 102474 then
				table.remove(element.values.elements, 2)
			end
		end
		table.insert(elm101017.values.on_executed, ref102095)
		kpr_original_missionmanager_addscript(self, data)
	end

elseif level_id == 'hox_1' then

	function MissionManager:_add_script(data)
		for _, element in pairs(data.elements) do
			if element.id == 100689 then
				element.values.instigator = 'enemies'
			end
		end
		kpr_original_missionmanager_addscript(self, data)
	end

elseif level_id == 'mex' then

	function MissionScript:_create_elements(elements)
		local grab_id = 150401
		local random_id = 150402
		local toggle_to_warp_ids = {
			[100879] = 150403,
			[100882] = 150404,
			[103170] = 150405,
		}
		local source_warp_ids = {
			[100939] = 150403,
			[100840] = 150404,
			[100992] = 150405,
		}
		local enable_jokers_id = 150406

		for _, element in pairs(elements) do
			if element.id == 100008 then
				for _, v in ipairs(element.values.on_executed) do
					if v.id == 102412 then
						v.delay = v.delay + 2.6
					end
				end
			elseif element.id == 101695 then
				table.insert(element.values.elements, enable_jokers_id)
			elseif element.id == 100957 then
				local element2 = CoreTable.deep_clone(element)
				element2.id = enable_jokers_id
				element2.editor_name = 'enable_area_grab_joker_teleport'
				element2.values.enabled = false
				element2.values.elements = { grab_id }
				table.insert(elements, element2)
				table.insert(kpr_custom_elements, enable_jokers_id)
			elseif element.id == 101026 then
				local element2 = CoreTable.deep_clone(element)
				element2.id = grab_id
				element2.editor_name = 'area_grab_joker_teleport'
				element2.values.instigator = 'intimidated_enemies'
				element2.values.trigger_times = 8
				element2.values.interval = 0.01
				element2.values.on_executed = {
					{ delay = 0, id = random_id }
				}
				table.insert(elements, element2)
				table.insert(kpr_custom_elements, grab_id)
			elseif element.id == 100878 then
				local element2 = CoreTable.deep_clone(element)
				element2.id = random_id
				element2.editor_name = 'random_jokers_spawn_mexico'
				element2.values.on_executed = {}
				for _, v in pairs(toggle_to_warp_ids) do
					table.insert(element2.values.on_executed, { delay = 0, id = v })
				end
				table.insert(elements, element2)
				table.insert(kpr_custom_elements, random_id)
			elseif toggle_to_warp_ids[element.id] then
				table.insert(element.values.elements, toggle_to_warp_ids[element.id])
			elseif source_warp_ids[element.id] then
				local wid = source_warp_ids[element.id]
				local element2 = CoreTable.deep_clone(element)
				element2.id = wid
				element2.editor_name = 'SO_teleport_jokers' .. element.editor_name:sub(-1)
				element2.values.trigger_times = 8
				local new_pos = Vector3()
				mvector3.set(new_pos, element2.values.position)
				mvector3.add(new_pos, Vector3(50, 0, 0))
				element2.values.position = new_pos
				table.insert(elements, element2)
				table.insert(kpr_custom_elements, wid)
			elseif element.id == 150400 then
				table.insert(element.values.elements, grab_id)
			end
		end

		return kpr_original_missionscript_createelements(self, elements)
	end

end
