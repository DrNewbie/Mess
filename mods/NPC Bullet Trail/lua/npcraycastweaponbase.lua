local idstr_trail = Idstring("trail")
local idstr_simulator_length = Idstring("simulator_length")
local idstr_size = Idstring("size")

local RCWeapon_NPCRaycastWeaponBase_fire_raycast = NPCRaycastWeaponBase._fire_raycast

function NPCRaycastWeaponBase:_fire_raycast(user_unit, from_pos, direction, dmg_mul, shoot_player, spread_mul, autohit_mul, suppr_mul, target_unit)
	if user_unit and alive(user_unit) and target_unit and alive(target_unit) and user_unit:base() and user_unit:base()._tweak_table and user_unit:base()._tweak_table then
		self.TRAIL_EFFECT = Idstring("effects/particles/weapons/sniper_trail")
		self._trail_effect_table = {
			effect = self.TRAIL_EFFECT,
			position = Vector3(),
			normal = Vector3()
		}
		self._trail_length = World:effect_manager():get_initial_simulator_var_vector2(self.TRAIL_EFFECT, idstr_trail, idstr_simulator_length, idstr_size)
		local col_ray = {
			distance = mvector3.distance(user_unit:position(), target_unit:position())
		}
		NPCSniperRifleBase._spawn_trail_effect(self, direction, col_ray)
	end
	return RCWeapon_NPCRaycastWeaponBase_fire_raycast(self, user_unit, from_pos, direction, dmg_mul, shoot_player, spread_mul, autohit_mul, suppr_mul, target_unit)
end