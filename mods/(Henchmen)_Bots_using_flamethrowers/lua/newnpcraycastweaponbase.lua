Hooks:PostHook(NewNPCRaycastWeaponBase, "init", "flamethrower_mk2_crew_init", function(self)
	if self._name_id and self._name_id == "flamethrower_mk2_crew" then
		self._flamethrower_init = true
		self._use_shell_ejection_effect = false
		self._use_trails = false
		self._rays = 6
		self._range = 1500
		self._flame_max_range = 1500
		self._single_flame_effect_duration = 1
		self._bullet_class = FlameBulletBase
		self._bullet_slotmask = managers.slot:get_mask("bullet_impact_targets_no_criminals")
		self._blank_slotmask = self._bullet_class:blank_slotmask()
		
		self:set_ammo_max(tweak_data.weapon[self._name_id].AMMO_MAX)
		self:set_ammo_total(self:get_ammo_max())
		self:set_ammo_max_per_clip(tweak_data.weapon[self._name_id].CLIP_AMMO_MAX)
		self:set_ammo_remaining_in_clip(self:get_ammo_max_per_clip())
		self._damage = tweak_data.weapon[self._name_id].DAMAGE
	end
end)

local mvec_to = Vector3()
local mvec_direction = Vector3()
local mvec_spread_direction = Vector3()

local flamethrower_mk2_crew_fire_raycast = NewNPCRaycastWeaponBase._fire_raycast
function NewNPCRaycastWeaponBase:_fire_raycast(user_unit, from_pos, direction, ...)
	if self._flamethrower_init then
		NewNPCFlamethrowerBase.fire_blank(self, direction)

		local damage = self:_get_current_damage(1)
		local damage_range = self._flame_max_range
		local spread_x, spread_y = 1, 1

		mvector3.set(mvec_to, direction)
		mvector3.multiply(mvec_to, damage_range)
		mvector3.add(mvec_to, from_pos)

		local col_ray = World:raycast("ray", from_pos, mvec_to, "slot_mask", self._bullet_slotmask, "ignore_unit", self._setup.ignore_units)

		if col_ray then
			damage_range = math.min(damage_range, col_ray.distance)
		else
			return {}
		end

		local cone_spread = math.rad(spread_x) * damage_range

		mvector3.set(mvec_to, direction)
		mvector3.multiply(mvec_to, damage_range)
		mvector3.add(mvec_to, from_pos)

		local hit_bodies = World:find_bodies(user_unit, "intersect", "cone", from_pos, mvec_to, cone_spread, self._bullet_slotmask)

		for idx, body in ipairs(hit_bodies) do
			local unit = body:unit()
			if unit and unit:character_damage() then
				unit:character_damage():damage_fire({
					variant = "fire",
					damage = damage,
					col_ray = col_ray,
					weapon_unit = self._unit,
					attacker_unit = user_unit,
					armor_piercing = true,
					fire_dot_data = tweak_data.weapon[self._name_id].fire_dot_data
				})
			end
		end

		return {}
	else
		return flamethrower_mk2_crew_fire_raycast(self, user_unit, from_pos, direction, ...)
	end
end