local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

if not Iter.settings.streamline_path then
	return
end

local mvec3_cpy = mvector3.copy
local mvec3_lerp = mvector3.lerp
local mvec3_set = mvector3.set
local mvec3_set_z = mvector3.set_z
local mvec3_z = mvector3.z

if Network:is_server() then

	function CopActionWalk:itr_check_extensible()
		if not self.itr_path_ahead then
			return
		end

		if self._end_of_curved_path or self._end_of_path or self._host_stop_pos_ahead then
			return
		end

		if self._haste ~= 'run' then
			return
		end

		if self._action_desc.path_simplified then
			return
		end

		return true
	end

	function CopActionWalk:itr_append_next_step(path)
		if not self:itr_check_extensible() then
			return
		end

		processed_path = {}
		for _, nav_point in pairs(path) do
			if nav_point.x then
				table.insert(processed_path, nav_point)
			elseif alive(nav_point) then
				table.insert(processed_path, {
					element = nav_point:script_data().element,
					c_class = nav_point
				})
			else
				return
			end
		end

		local nr = #self._simplified_path
		self.itr_step_pos = self._nav_point_pos(self._simplified_path[nr])
		local good_pos = mvec3_cpy(self.itr_step_pos)
		local simplified_path = self._calculate_simplified_path(good_pos, processed_path, (not self._sync or self._common_data.stance.name == 'ntl') and 2 or 1, self._sync, true)

		for i = 2, #simplified_path do
			nr = nr + 1
			self._simplified_path[nr] = simplified_path[i]
		end

		return true
	end

	local itr_original_copactionwalk_advancesimplifiedpath = CopActionWalk._advance_simplified_path
	function CopActionWalk:_advance_simplified_path()
		if self:itr_check_extensible() then
			self.fs_wanted_walk_dir_cached = nil
			self.fs_move_dir_norm_cached = nil
			if self._nav_point_pos(self._simplified_path[2]) == self.itr_step_pos then
				self.itr_fake_complete = true
				self._unit:brain():action_complete_clbk(self)
				self.itr_fake_complete = nil
			end
		end

		itr_original_copactionwalk_advancesimplifiedpath(self)
	end

	local itr_original_CopActionWalk_onexit = CopActionWalk.on_exit
	function CopActionWalk:on_exit()
		self.itr_path_ahead = false
		return itr_original_CopActionWalk_onexit(self)
	end

end

function CopActionWalk:itr_delete_path_ahead()
	if not self.itr_step_pos then
		return
	end

	local s_path = self._simplified_path
	if s_path[1] == self.itr_step_pos then
		self._expired = true
		return
	end

	for i = 2, #s_path do
		pos = s_path[i]
		if pos == self.itr_step_pos then
			i = i + 1
			while s_path[i] do
				table.remove(s_path, i)
			end
			break
		end
	end
end

local tmp_vec1 = Vector3()
local tmp_vec2 = Vector3()

local _chk_shortcut_pos_to_pos_params = CopActionWalk._chk_shortcut_pos_to_pos_params
local _qf, _obstacle_mask
DelayedCalls:Add('DelayedModITR_quadfield', 0, function()
	_qf = managers.navigation._quad_field
	_obstacle_mask = managers.slot:get_mask('AI_graph_obstacle_check')
end)

function CopActionWalk._chk_shortcut_pos_to_pos(from, to, trace)
	local params = _chk_shortcut_pos_to_pos_params
	params.pos_from = from
	params.pos_to = to
	params.trace = trace

	local res = _qf:test_walkability(params)
	if res then
		local from_z = mvec3_z(from)
		local to_z = mvec3_z(to)
		local min_z, max_z = math.min_max(from_z, to_z)
		if max_z - min_z < 40 then
			local raised_from = tmp_vec1
			mvec3_set(raised_from, from)
			mvec3_set_z(raised_from, from_z + 65)

			local raised_to = tmp_vec2
			mvec3_set(raised_to, to)
			mvec3_set_z(raised_to, to_z + 65)

			local res2 = World:raycast('ray', raised_from, raised_to, 'sphere_cast_radius', 20, 'slot_mask', _obstacle_mask, 'ray_type', 'walk', 'report')
			if not res2 then
				local middle_up = tmp_vec1
				mvec3_lerp(middle_up, from, to, 0.5)
				mvec3_set_z(middle_up, max_z)

				local middle_down = tmp_vec2
				mvec3_set(middle_down, middle_up)
				mvec3_set_z(middle_down, min_z - 100)

				local res3 = World:raycast('ray', middle_up, middle_down, 'slot_mask', _obstacle_mask, 'ray_type', 'walk')
				if res3 and res3.distance < 40 then
					return res2, trace and {to}
				end
			end
		end
	end

	return res, params.trace
end
