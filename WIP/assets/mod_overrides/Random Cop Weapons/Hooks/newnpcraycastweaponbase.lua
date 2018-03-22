local mvec_spread_direction = Vector3()

function NewNPCRaycastWeaponBase:_adjust_throw_z(m_vec)
end

local RCWeapon_NewNPCRaycastWeaponBase_fire_raycast = NewNPCRaycastWeaponBase._fire_raycast

function NewNPCRaycastWeaponBase:_fire_raycast(user_unit, from_pos, direction, dmg_mul, shoot_player, shoot_through_data)
	if not self.launcher_projectile_check then
		self.launcher_projectile_check = true
		if tweak_data.blackmarket and tweak_data.blackmarket.projectiles and self._factory_id and managers.weapon_factory then
			local _factory_id = self._factory_id:gsub("_npc", "")
			local weapon_id = managers.weapon_factory:get_weapon_id_by_factory_id(_factory_id)
			if weapon_id then
				for i, d in pairs(tweak_data.blackmarket.projectiles) do
					if tostring(d.weapon_id) == weapon_id then
						self.launcher_projectile = i
						break
					end
				end
			end
		end
	end
	if not self.launcher_projectile then
		return RCWeapon_NewNPCRaycastWeaponBase_fire_raycast(self, user_unit, from_pos, direction, dmg_mul, shoot_player, shoot_through_data)
	else
		self._ammo_data = {launcher_grenade = self.launcher_projectile}
		local unit = nil
		local weapon_base = self._unit:base()
		local spread_x, spread_y = weapon_base:_get_spread(user_unit)
		local right = direction:cross(Vector3(0, 0, 1)):normalized()
		local up = direction:cross(right):normalized()
		local theta = math.random() * 360
		local ax = math.sin(theta) * math.random() * spread_x * (spread_mul or 1)
		local ay = math.cos(theta) * math.random() * spread_y * (spread_mul or 1)
		mvector3.set(mvec_spread_direction, direction)
		mvector3.add(mvec_spread_direction, right * math.rad(ax))
		mvector3.add(mvec_spread_direction, up * math.rad(ay))
		local projectile_type = self.launcher_projectile
		local projectile_type_index = tweak_data.blackmarket:get_index_from_projectile_id(projectile_type)
		self:_adjust_throw_z(mvec_spread_direction)
		mvec_spread_direction = mvec_spread_direction * 1
		self._dmg_mul = dmg_mul or 1
		if not self._client_authoritative then
			unit = ProjectileBase.throw_projectile_alt(nil, projectile_type, from_pos, mvec_spread_direction, nil)
		end
		managers.statistics:shot_fired({
			hit = false,
			weapon_unit = weapon_base._unit
		})
		weapon_base:check_bullet_objects()
		return {}
	end
end