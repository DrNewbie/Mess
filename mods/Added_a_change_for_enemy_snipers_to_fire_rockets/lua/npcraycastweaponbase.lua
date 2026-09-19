if Network:is_client() then
	return
end

local RCWeapon_NPCRaycastWeaponBase_fire_raycast = NPCRaycastWeaponBase._fire_raycast

function NPCRaycastWeaponBase:_fire_raycast(user_unit, from_pos, direction, dmg_mul, shoot_player, spread_mul, autohit_mul, suppr_mul, target_unit)
	if math.random()*1000 < 15 and user_unit and alive(user_unit) and target_unit and alive(target_unit) and user_unit:base() and user_unit:base()._tweak_table and user_unit:base()._tweak_table == "sniper" then
		local unit = nil
		local mvec_from_pos = Vector3()
		local mvec_direction = Vector3()
		mvector3.set(mvec_from_pos, from_pos)
		mvector3.set(mvec_direction, direction)
		mvector3.multiply(mvec_direction, 100)
		mvector3.add(mvec_from_pos, mvec_direction)
		if not self._client_authoritative then
			unit = ProjectileBase.throw_projectile("rocket_frag", mvec_from_pos, direction)
		end
		return {}
	end
	return RCWeapon_NPCRaycastWeaponBase_fire_raycast(self, user_unit, from_pos, direction, dmg_mul, shoot_player, spread_mul, autohit_mul, suppr_mul, target_unit)
end