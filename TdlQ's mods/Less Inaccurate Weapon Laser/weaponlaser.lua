local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local mvec3_set = mvector3.set
local mvec3_add = mvector3.add
local mvec3_mul = mvector3.multiply
local mvec3_neg = mvector3.negate
local mvec3_rot = mvector3.rotate_with

local mvec1 = Vector3()
local mvec2 = Vector3()
local mvec3 = Vector3()
local mvec_l_dir = Vector3()

function WeaponLaser:update(unit, t, dt)
	local rotation = self._custom_rotation or self._laser_obj:rotation()
	mrotation.y(rotation, mvec_l_dir)

	local from = mvec1
	if self._custom_position then
		mvec3_set(from, self._laser_obj:local_position())
		mvec3_rot(from, rotation)
		mvec3_add(from, self._custom_position)
	else
		mvec3_set(from, self._laser_obj:position())
	end

	local to = mvec2
	mvec3_set(to, mvec_l_dir)
	mvec3_mul(to, self._max_distance)

	local camera
	local raycast_from = mvec3
	if self.liwl_is_local_player then
		local player_unit = managers.player:player_unit()
		camera = player_unit and player_unit:camera()
	end
	if camera then
		mvec3_set(raycast_from, self.liwl_previous_raycast_from)
		mvec3_set(self.liwl_previous_raycast_from, camera:position())
		mvec3_add(to, raycast_from)
	else
		raycast_from = from
		mvec3_add(to, from)
	end

	local ray = self._unit:raycast('ray', raycast_from, to, 'slot_mask', self._slotmask, self._ray_ignore_units and 'ignore_unit' or nil, self._ray_ignore_units)
	if ray then
		if not self._is_npc then
			self._light:set_spot_angle_end(self._spot_angle_end)
			self._spot_angle_end = math.lerp(1, 18, ray.distance / self._max_distance)
			self._light_glow:set_spot_angle_end(math.lerp(8, 80, ray.distance / self._max_distance))

			local scale = (math.clamp(ray.distance, self._max_distance - self._scale_distance, self._max_distance) - (self._max_distance - self._scale_distance)) / self._scale_distance
			scale = 1 - scale
			self._light:set_multiplier(scale)
			self._light_glow:set_multiplier(scale * 0.1)
		end
		self._brush:cylinder(ray.position, from, self._is_npc and 0.5 or 0.25)

		local pos = mvec1
		mvec3_set(pos, mvec_l_dir)
		mvec3_mul(pos, 50)
		mvec3_neg(pos)
		mvec3_add(pos, ray.position)
		self._light:set_final_position(pos)
		self._light_glow:set_final_position(pos)
	else
		self._light:set_final_position(to)
		self._light_glow:set_final_position(to)
		self._brush:cylinder(from, to, self._is_npc and 0.5 or 0.25)
	end

	self._custom_position = nil
	self._custom_rotation = nil
end
