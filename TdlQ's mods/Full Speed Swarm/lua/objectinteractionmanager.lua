local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

if _G.IS_VR then
	return
end

local table_insert = table.insert
local table_remove = table.remove
local ordered_list = {}

function ObjectInteractionManager:reset_ordered_list()
	for _, item in ipairs(ordered_list) do
		item.time = 0
		item.dot = 0
	end
end

local fs_original_objectinteractionmanager_addunit = ObjectInteractionManager.add_unit
function ObjectInteractionManager:add_unit(unit)
	fs_original_objectinteractionmanager_addunit(self, unit)
	self:add_unit_to_ordered_list(unit)
end

function ObjectInteractionManager:add_unit_to_ordered_list(unit)
	table_insert(ordered_list, {
		time = 0,
		dot = 0,
		key = unit:key(),
		unit = unit
	})
end

local fs_original_objectinteractionmanager_removeunit = ObjectInteractionManager.remove_unit
function ObjectInteractionManager:remove_unit(unit)
	fs_original_objectinteractionmanager_removeunit(self, unit)
	self:remove_unit_from_ordered_list(unit:key())
end

function ObjectInteractionManager:remove_unit_from_ordered_list(u_key)
	for i, item in ipairs(ordered_list) do
		if u_key == item.key then
			table_remove(ordered_list, i)
			break
		end
	end
end

function ObjectInteractionManager:update(t, dt)
	if self._interactive_count > 0 then
		local player_unit = managers.player:player_unit()
		if alive(player_unit) then
			local player_pos = player_unit:movement():m_head_pos()
			self:_update_targeted(player_pos, player_unit, nil, nil, t)
		end
	end
end

local MAX_SPEED
local mvec1 = Vector3()
local mvec3_dis = mvector3.distance
local mvec3_set = mvector3.set
local mvec3_sub = mvector3.subtract
local mvec3_norm = mvector3.normalize
local mvec3_dot = mvector3.dot
local math_floor = math.floor
local math_max = math.max
function ObjectInteractionManager:_update_targeted(player_pos, player_unit, hand_unit, hand_id, t)
	local active_unit, closest_locator, last_active_interaction
	local last_active = self._active_unit
	if alive(last_active) then
		last_active_interaction = last_active:interaction()
	else
		last_active = nil
	end

	if self._active_object_locked_data then
		if not last_active_interaction or not last_active_interaction:active() then
			self._active_object_locked_data = nil
		else
			local distance = mvec3_dis(player_pos, last_active_interaction:interact_position())
			if last_active_interaction:interact_dont_interupt_on_distance() or distance <= last_active_interaction:interact_distance() then
				return
			end
		end
	end

	if player_unit:movement():object_interaction_blocked() then
		if last_active then
			last_active_interaction:unselect()
			self._active_unit = nil
		end
		return
	end

	local current_dot = last_active and self._current_dot or 0.9
	local best_current_dot = 0
	local last_active_locator = self._active_locator

	local ordered_list_nr = #ordered_list
	if ordered_list_nr > 0 then
		MAX_SPEED = MAX_SPEED or tweak_data.player.movement_state.standard.movement.speed.RUNNING_MAX * managers.player:fs_max_movement_speed_multiplier()
		local player_fwd = player_unit:camera():forward()
		local camera_pos = player_unit:camera():position()
		local item = ordered_list[ordered_list_nr]
		while item.time <= t do
			local unit = item.unit
			if alive(unit) then
				local interaction = unit:interaction()
				local i_dis = interaction:interact_distance()
				local i_pos = interaction:interact_position()
				local distance = mvec3_dis(player_pos, i_pos)

				if distance <= i_dis and distance >= interaction:max_interact_distance() then
					if interaction:ray_objects() and unit:vehicle_driving() then
						for _, locator in ipairs(interaction:ray_objects()) do
							mvec3_set(mvec1, locator:position())
							mvec3_sub(mvec1, camera_pos)
							mvec3_norm(mvec1)
							local dot = mvec3_dot(player_fwd, mvec1)
							if dot > 0.9 and interaction:can_select(player_unit, locator) and mvec3_dis(player_unit:position(), locator:position()) <= i_dis and (current_dot <= dot or locator == last_active_locator and dot > 0.9) then
								local interact_axis = interaction:interact_axis()
								if (not interact_axis or 0 > mvec3_dot(mvec1, interact_axis)) and self:_raycheck_ok(unit, camera_pos, locator) then
									if closest_locator and player_unit then
										if mvec3_dis(player_unit:position(), locator:position()) < mvec3_dis(player_unit:position(), closest_locator:position()) then
											closest_locator = locator
											item.dot = dot
										end
									else
										closest_locator = locator
										item.dot = dot
									end
									current_dot = dot
									active_unit = unit
								end
							end
						end
						self._active_locator = closest_locator
					elseif interaction:can_select(player_unit) then
						mvec3_set(mvec1, i_pos)
						mvec3_sub(mvec1, camera_pos)
						mvec3_norm(mvec1)
						local dot = mvec3_dot(player_fwd, mvec1)
						item.dot = dot
						if dot > current_dot or unit == last_active and dot > 0.9 and dot >= best_current_dot then
							local interact_axis = interaction:interact_axis()
							if (not interact_axis or mvec3_dot(mvec1, interact_axis) < 0) and self:_raycheck_ok(unit, camera_pos) then
								current_dot = dot
								best_current_dot = dot
								active_unit = unit
								self._active_locator = nil
							end
						end
					end
				else
					item.dot = 0
				end

				local dt = math_max(0.001, (distance - i_dis) / MAX_SPEED) -- human speed only, that's why table is reset when exiting a vehicle
				local new_t = t + dt
				item.time = new_t
				local new_rank
				if dt > 0.1 then
					-- thanks to http://lua-users.org/wiki/BinaryInsert
					local iStart, iEnd, iMid, iState = 1, ordered_list_nr - 1, 1, 0
					while iStart <= iEnd do
						iMid = math_floor((iStart + iEnd) * 0.5)
						local i = iMid
						local mid_t = ordered_list[iMid].time
						if new_t == mid_t then
							break
						elseif new_t > mid_t then
							iEnd, iState = iMid - 1, 0
						else
							iStart, iState = iMid + 1, 1
						end
					end
					new_rank = iMid + iState
					if new_rank == ordered_list_nr then
						break
					end
					item = table_remove(ordered_list)
					table_insert(ordered_list, new_rank, item)
				else
					new_rank = 1
					for i = ordered_list_nr - 1, 1, -1 do
						local item_i = ordered_list[i]
						if new_t < item_i.time or new_t == item_i.time and item.dot > item_i.dot then
							new_rank = i + 1
							break
						end
						ordered_list[i + 1] = item_i
					end
					if new_rank == ordered_list_nr then
						break
					end
					ordered_list[new_rank] = item
				end
			else
				table_remove(ordered_list, ordered_list_nr)
				break
			end

			item = ordered_list[ordered_list_nr]
		end
	end

	if active_unit and last_active ~= active_unit then
		if last_active then
			last_active_interaction:unselect()
		end
		if not active_unit:interaction():selected(player_unit, self._active_locator, hand_id) then
			active_unit = nil
		end
	elseif self._active_locator and self._active_locator ~= last_active_locator then
		last_active_interaction:unselect()
		if not last_active_interaction:selected(player_unit, self._active_locator, hand_id) then
			active_unit = nil
			self._active_locator = nil
		end
	elseif last_active and last_active_interaction:dirty() then
		last_active_interaction:set_dirty(false)
		last_active_interaction:unselect()
		if not last_active_interaction:selected(player_unit, self._active_locator, hand_id) then
			active_unit = nil
		end
	end
	self._active_unit = active_unit
	self._current_dot = current_dot

	if last_active and not active_unit then
		last_active_interaction:unselect()
	end
end
