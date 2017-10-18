function PlayerEquipment:valid_look_at_placement(equipment_data)
	local from = self._unit:movement():m_head_pos()
	local to = from + self._unit:movement():m_head_rot():y() * 200
	local ray = self._unit:raycast("ray", from, to, "slot_mask", managers.slot:get_mask("trip_mine_placeables"), "ignore_unit", {}, "ray_type", "equipment_placement")

	if ray and equipment_data and equipment_data.dummy_unit then
		local pos = ray.position
		local rot = self._unit:movement():m_head_rot()
		if equipment_data.use_function_name == "use_sentry_gun" then
			local rot_pitch = math.round(rot:pitch())
			if rot_pitch < 66 and rot_pitch > -66 then
				rot_pitch = 90
			elseif rot_pitch >= 66 then
				rot_pitch = 180
			else
				rot_pitch = 0
			end
			rot = Rotation(ray.normal, math.UP)
		end

		if not alive(self._dummy_unit) then
			self._dummy_unit = World:spawn_unit(Idstring(equipment_data.dummy_unit), pos, rot)

			self:_disable_contour(self._dummy_unit)
		end

		self._dummy_unit:set_position(pos)
		self._dummy_unit:set_rotation(rot)
	end

	if alive(self._dummy_unit) then
		self._dummy_unit:set_enabled(ray and true or false)
	end

	return ray
end