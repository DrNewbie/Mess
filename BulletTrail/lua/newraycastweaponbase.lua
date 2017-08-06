_G.AddBulletTrail = _G.AddBulletTrail or {}

local HookAddBulletTrail = NewRaycastWeaponBase.fire
local idstr_trail = Idstring("trail")
local idstr_simulator_length = Idstring("simulator_length")
local idstr_size = Idstring("size")

function NewRaycastWeaponBase:fire(from_pos, direction, ...)
	if AddBulletTrail.Settings[tostring(self._name_id)] then
		self.TRAIL_EFFECT = Idstring("effects/particles/weapons/sniper_trail")
		self._trail_effect_table = {
			effect = self.TRAIL_EFFECT,
			position = Vector3(),
			normal = Vector3()
		}
		self._trail_length = World:effect_manager():get_initial_simulator_var_vector2(self.TRAIL_EFFECT, idstr_trail, idstr_simulator_length, idstr_size)
		local col_ray = {
			distance = 1000
		}
		NPCSniperRifleBase._spawn_trail_effect(self, direction, col_ray)
	end
	return HookAddBulletTrail(self, from_pos, direction, ...)
end