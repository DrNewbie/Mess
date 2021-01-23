Hooks:PostHook(ECMJammerBase, 'init', 'F_'..Idstring('init:ECM Laser'):key(), function(self)
	self._use_draw_laser = true
	self._laser_color = Color(0.15, 1, 0, 0)
	self._laser_sensor_color = Color(0.15, 0.1, 0.1, 1)
	self._laser_brush = Draw:brush(self._laser_color, "VertexColor")
	self._laser_brush:set_blend_mode("opacity_add")
	self._forward = self._rotation:y()
	self._ray_from_pos = Vector3()
	self._ray_to_pos = Vector3()
	self._init_length = 5000
	self._length = self._init_length
end)

function ECMJammerBase:_raycast()
	return self._unit:raycast("ray", self._ray_from_pos, self._ray_to_pos, "slot_mask", self._slotmask, "ray_type", "trip_mine body")
end

function ECMJammerBase:_sensor(t)
	local ray = self:_raycast()
	if ray and ray.unit and not tweak_data.character[ray.unit:base()._tweak_table].is_escort then
		self._sensor_units_detected = self._sensor_units_detected or {}
		if not self._sensor_units_detected[ray.unit:key()] then
			self._sensor_units_detected[ray.unit:key()] = true
			managers.game_play_central:auto_highlight_enemy(ray.unit, true)
			self._unit:sound_source():post_event("trip_mine_sensor_alarm")
			self._sensor_last_unit_time = t + 5
		end
	end
end

Hooks:PostHook(ECMJammerBase, 'update', 'F_'..Idstring('update:ECM Laser'):key(), function(self, unit, t)
	if self._use_draw_laser and self._laser_brush then
		local from_pos = self._unit:position() + self._unit:rotation():y() * 10
		local to_pos = from_pos + self._unit:rotation():y() * self._init_length
		local ray = self._unit:raycast("ray", from_pos, to_pos, "slot_mask", managers.slot:get_mask("world_geometry"))
		self._length = math.clamp(ray and ray.distance + 10 or self._init_length, 0, self._init_length)
		mvector3.set(self._ray_from_pos, self._unit:position())
		mvector3.set(self._ray_to_pos, self._forward)
		mvector3.multiply(self._ray_to_pos, self._length)
		mvector3.add(self._ray_to_pos, self._ray_from_pos)		
		self._laser_brush:cylinder(self._ray_from_pos, self._ray_to_pos, 0.5)
		self:_sensor(t)
		if self._sensor_units_detected and self._sensor_last_unit_time and self._sensor_last_unit_time < t then
			self._sensor_units_detected = nil
			self._sensor_last_unit_time = nil
		end
	end
end)