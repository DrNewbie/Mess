local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local table_insert = table.insert
local table_remove = table.remove
local math_ceil = math.ceil
local math_min = math.min

local WGT_OCCLUDED = 40000000000000
local WGT_UNKNOWN  = 39000000000000

local task_throughput
function FullSpeedSwarm:UpdateMaxTaskThroughputLocally(new_value)
	task_throughput = math.clamp(new_value or self.settings.task_throughput, 180, 3000)
end
FullSpeedSwarm:UpdateMaxTaskThroughputLocally()

function EnemyManager:_update_queued_tasks(t, dt)
	local qt = self._queued_tasks
	local n = math_ceil(dt * task_throughput)
	local i_task = 1

	local task_data = qt[i_task]
	while task_data do
		if task_data.t == nil or t > task_data.t then
			self:_execute_queued_task(i_task)
			n = n - 1
			if n <= 0 then
				break
			end
		else
			i_task = i_task + 1
		end
		task_data = qt[i_task]
	end

	local all_clbks = self._delayed_clbks
	if all_clbks[1] and t > all_clbks[1][2] then
		local clbk = table_remove(all_clbks, 1)[3]
		clbk()
	end
end

local fs_original_enemymanager_initenemydata = EnemyManager._init_enemy_data
function EnemyManager:_init_enemy_data()
	fs_original_enemymanager_initenemydata(self)
	self._enemy_data.announcer_data = {}
	self.iter_lod = 1
	self.lowest_occluded_rank = 1
	self._gfx_lod_data.entries.last_check_t = {}
end

local mvec3_dir = mvector3.direction
local mvec3_dot = mvector3.dot
local tmp_vec1 = Vector3()
local frm = 1
local lod_step = tonumber(FullSpeedSwarm.settings.lod_updater)
if lod_step < 3 then
	function EnemyManager:_update_gfx_lod()
		local managers = managers
		if self._gfx_lod_data.enabled and managers.navigation:is_data_ready() then
			local camera_rot = managers.viewport:get_current_camera_rotation()
			if camera_rot then
				local cam_pos
				local pl_fwd = camera_rot:y()
				local player = managers.player:player_unit()
				if player then
					cam_pos = player:movement():m_head_pos()
				else
					cam_pos = managers.viewport:get_current_camera_position()
				end

				local entries = self._gfx_lod_data.entries
				local states = entries.states
				local nr = #states
				local anim_lod = managers.user:get_setting('video_animation_lod')
				local nr_lod_1 = self._nr_i_lod[anim_lod][1]
				local nr_lod_2 = self._nr_i_lod[anim_lod][2]
				local nr_lod_total = nr_lod_1 + nr_lod_2

				local units = entries.units
				local trackers = entries.trackers
				local com = entries.com
				local last_check_t = entries.last_check_t
				local unit_occluded = Unit.occluded
				local occ_skip_units = managers.occlusion._skip_occlusion
				local World = World
				local world_in_view_with_options = World.in_view_with_options
				local sorted_index = self._gfx_lod_data.prio_i
				local weights = self._gfx_lod_data.prio_weights

				local lowest_occluded_rank = self.lowest_occluded_rank
				frm = (frm + 1) % lod_step
				for s = lowest_occluded_rank + frm, nr, lod_step do
					local i = sorted_index[s]
					local unit = units[i]
					if not unit_occluded(unit) and world_in_view_with_options(World, com[i], 0, 110, 18000) then
						sorted_index[s], sorted_index[lowest_occluded_rank] = sorted_index[lowest_occluded_rank], sorted_index[s]
						lowest_occluded_rank = lowest_occluded_rank + 1
						weights[i] = WGT_UNKNOWN
						states[i] = 2
						unit:base():set_visibility_state(2)
					end
				end

				local max_iter = nr / 25
				local threshold_t = max_iter * 0.02
				local s = self.iter_lod
				local looping = false
				repeat
					local i
					max_iter = max_iter - 1
					while true do
						if s >= lowest_occluded_rank or s > nr then
							s = 1
							looping = true
							break
						end
						i = sorted_index[s]
						if self._t - last_check_t[i] > threshold_t  then
							break
						end
						s = s + 1
					end
					if looping then
						break
					end

					last_check_t[i] = self._t

					local my_wgt
					local unit = units[i]
					if not (occ_skip_units[unit:key()] or not unit_occluded(unit) and world_in_view_with_options(World, com[i], 0, 120, 18000)) then
						my_wgt = WGT_OCCLUDED
					else
						my_wgt = mvec3_dir(tmp_vec1, cam_pos, com[i])
						local dot = mvec3_dot(tmp_vec1, pl_fwd)
						my_wgt = my_wgt * my_wgt * (1 - dot)
					end

					local new_rank
					local weight_i = weights[i]
					if my_wgt == weight_i then
						new_rank = s
					elseif my_wgt > weight_i then
						new_rank = nr
						for s2 = s, nr - 1 do
							local si2 = sorted_index[s2 + 1]
							if weights[si2] >= my_wgt then
								new_rank = s2
								break
							else
								sorted_index[s2] = si2
							end
						end
						if s <= nr_lod_total and lowest_occluded_rank > nr_lod_total then
							states[nr_lod_total] = 2
							units[nr_lod_total]:base():set_visibility_state(2)
							if s <= nr_lod_1 and lowest_occluded_rank > nr_lod_1 then
								states[nr_lod_1] = 1
								units[nr_lod_1]:base():set_visibility_state(1)
							end
						end
						sorted_index[new_rank] = i
					else
						new_rank = 1
						for s2 = s, 2, -1 do
							local si2 = sorted_index[s2 - 1]
							if weights[si2] <= my_wgt then
								new_rank = s2
								break
							else
								sorted_index[s2] = si2
							end
						end
						if s > nr_lod_1 then
							local nr_lod_1_p_1 = nr_lod_1 + 1
							if lowest_occluded_rank > nr_lod_1_p_1 then
								states[nr_lod_1_p_1] = 2
								units[nr_lod_1_p_1]:base():set_visibility_state(2)
								if s > nr_lod_total then
									local nr_lod_total_p_1 = nr_lod_total + 1
									if lowest_occluded_rank > nr_lod_total_p_1 then
										states[nr_lod_total_p_1] = 3
										units[nr_lod_total_p_1]:base():set_visibility_state(3)
									end
								end
							end
						end
						sorted_index[new_rank] = i
					end
					if new_rank <= s then
						s = s + 1
					end

					local new_state
					if my_wgt == WGT_OCCLUDED then
						new_state = false
					elseif new_rank <= nr_lod_total then
						new_state = new_rank <= nr_lod_1 and 1 or 2
					else
						new_state = 3
					end
					if new_state ~= states[i] then
						states[i] = new_state
						unit:base():set_visibility_state(new_state)
						if not new_state then
							lowest_occluded_rank = lowest_occluded_rank - 1
						end
					end

					weights[i] = my_wgt
				until max_iter <= 0
				self.iter_lod = s

				self.lowest_occluded_rank = lowest_occluded_rank
			end
		end
	end

	function EnemyManager:_create_unit_gfx_lod_data(unit)
		if not unit:alive() then
			return
		end

		local gfx_lod_data = self._gfx_lod_data
		local lod_entries = gfx_lod_data.entries
		table_insert(lod_entries.units, unit)
		table_insert(lod_entries.states, 42)
		table_insert(lod_entries.move_ext, unit:movement())
		table_insert(lod_entries.trackers, unit:movement():nav_tracker())
		table_insert(lod_entries.com, unit:movement():m_com())
		table_insert(lod_entries.last_check_t, 0)

		local weights = gfx_lod_data.prio_weights
		table_insert(weights, WGT_UNKNOWN)

		local sorted_index = gfx_lod_data.prio_i
		table_insert(sorted_index, self.lowest_occluded_rank, #weights)
		self.lowest_occluded_rank = self.lowest_occluded_rank + 1
	end

	function EnemyManager:_destroy_unit_gfx_lod_data(u_key)
		local gfx_lod_data = self._gfx_lod_data
		local lod_entries = gfx_lod_data.entries
		local units = lod_entries.units
		local nr_entries = #units
		for i = 1, nr_entries do
			local unit = units[i]
			if u_key == unit:key() then
				local ub = unit:base()
				if ub._tweak_table == 'sniper' then
					ub:set_visibility_state(1)
				end

				local sorted_index = gfx_lod_data.prio_i
				for j = nr_entries, 1, -1 do
					local s = sorted_index[j]
					if s == nr_entries then
						for k = j, 1, -1 do
							if sorted_index[k] == i then
								sorted_index[j] = i
								table_remove(sorted_index, k)
								break
							end
						end
						break
					end
					if s == i then
						table_remove(sorted_index, j)
						for k = j - 1, 1, -1 do
							if sorted_index[k] == nr_entries then
								sorted_index[k] = i
								break
							end
						end
						break
					end
				end

				units[i] = units[nr_entries]
				table_remove(units)
				lod_entries.states[i] = lod_entries.states[nr_entries]
				table_remove(lod_entries.states)
				lod_entries.move_ext[i] = lod_entries.move_ext[nr_entries]
				table_remove(lod_entries.move_ext)
				lod_entries.trackers[i] = lod_entries.trackers[nr_entries]
				table_remove(lod_entries.trackers)
				lod_entries.com[i] = lod_entries.com[nr_entries]
				table_remove(lod_entries.com)

				if gfx_lod_data.prio_weights[i] ~= WGT_OCCLUDED and self.lowest_occluded_rank > 1 then
					self.lowest_occluded_rank = self.lowest_occluded_rank - 1
				end
				gfx_lod_data.prio_weights[i] = gfx_lod_data.prio_weights[nr_entries]
				table_remove(gfx_lod_data.prio_weights)

				lod_entries.last_check_t[i] = lod_entries.last_check_t[nr_entries]
				table_remove(lod_entries.last_check_t)
				break
			end
		end
	end

	function EnemyManager:set_gfx_lod_enabled(state)
		if state then
			self._gfx_lod_data.enabled = state
		elseif self._gfx_lod_data.enabled then
			self._gfx_lod_data.enabled = state
			local entries = self._gfx_lod_data.entries
			local units = entries.units
			local states = entries.states
			local weights = self._gfx_lod_data.prio_weights
			for i, state in ipairs(states) do
				states[i] = 1
				weights[i] = WGT_UNKNOWN
				units[i]:base():set_visibility_state(1)
			end
		end
	end
end

local fs_announcers = {}
DelayedCalls:Add('DelayedModFSS_buildannouncers', 0, function()
	local fs_announcables = {}
	for ctype, tdc in pairs(tweak_data.character) do
		if type(tdc) == 'table' and tdc.announce_incomming then
			fs_announcables[ctype] = tdc.announce_incomming
		end
	end

	for ctype, tdc in pairs(tweak_data.character) do
		if type(tdc) == 'table' and tdc.chatter then
			for _, a in pairs(fs_announcables) do
				if tdc.chatter[a] then
					fs_announcers[ctype] = true
					break
				end
			end
		end
	end
end)

local fs_original_enemymanager_registerenemy = EnemyManager.register_enemy
function EnemyManager:register_enemy(enemy)
	fs_original_enemymanager_registerenemy(self, enemy)

	local e_key = enemy:key()
	local u_data = self._enemy_data.unit_data[e_key]
	local _tweak_table = enemy:base()._tweak_table
	u_data.tweak_table = _tweak_table
	if fs_announcers[_tweak_table] then
		self._enemy_data.announcer_data[e_key] = u_data
	end

	enemy:movement().fs_do_track = u_data
end

local fs_original_enemymanager_onenemyunregistered = EnemyManager.on_enemy_unregistered
function EnemyManager:on_enemy_unregistered(unit)
	fs_original_enemymanager_onenemyunregistered(self, unit)
	local u_key = unit:key()
	self._enemy_data.announcer_data[u_key] = nil

	local u_mov = unit:movement()
	u_mov.fs_do_track = nil
	if u_mov.fs_cur_seg then
		FullSpeedSwarm.units_per_navseg[u_mov.fs_cur_seg][u_key] = nil
		u_mov.fs_cur_seg = nil
	end
end

function EnemyManager:all_enemy_announcers()
	return self._enemy_data.announcer_data
end

local fs_original_enemymanager_onenemydied = EnemyManager.on_enemy_died
function EnemyManager:on_enemy_died(dead_unit, damage_info)
	fs_original_enemymanager_onenemydied(self, dead_unit, damage_info)
	local u_data = self._enemy_data.corpses[dead_unit:key()]
	if not u_data.m_pos then
		u_data.m_pos = dead_unit:position()
	end
	if Network:is_client() and not self:is_corpse_disposal_enabled() then
		Network:detach_unit(dead_unit)
	end
end

if Network:is_client() then
	local fs_original_enemymanager_onciviliandied = EnemyManager.on_civilian_died
	function EnemyManager:on_civilian_died(dead_unit, damage_info)
		fs_original_enemymanager_onciviliandied(self, dead_unit, damage_info)
		if not self:is_corpse_disposal_enabled() then
			Network:detach_unit(dead_unit)
		end
	end
end
