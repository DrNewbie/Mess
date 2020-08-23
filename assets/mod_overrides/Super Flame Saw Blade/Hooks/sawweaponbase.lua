local wpn_fids = Idstring("wpn_fps_saw_m_blade_flame"):key()
local is_wpn_fids = "__F_"..Idstring('is_wpn_fids:'..wpn_fids):key()

Hooks:PostHook(SawWeaponBase, "setup", "F_"..Idstring("PostHook:SawWeaponBase:setup:"..wpn_fids):key(), function(self)
	if type(self._blueprint) == "table" and table.contains(self._blueprint, "wpn_fps_saw_m_blade_flame") then
		self[is_wpn_fids] = true

	end
end)

Hooks:PostHook(SawHit, "on_collision", "F_"..Idstring("PostHook:SawHit:on_collision:"..wpn_fids):key(), function(self, col_ray, weapon_unit, user_unit, ...)
	local hit_unit = col_ray.unit
	local is_shield = hit_unit:in_slot(8) and alive(hit_unit:parent())
	if is_shield then
		hit_unit = hit_unit:parent()
	end
	if hit_unit and hit_unit.character_damage and hit_unit:character_damage() and hit_unit:character_damage().damage_fire and weapon_unit and weapon_unit:base() and weapon_unit:base()[is_wpn_fids] then
		hit_unit:character_damage():damage_fire({
			variant = "fire",
			damage = 1,
			weapon_unit = weapon_unit,
			attacker_unit = user_unit,
			col_ray = col_ray,
			armor_piercing = true,
			fire_dot_data = {
				dot_trigger_chance = "100",
				dot_damage = "10",
				dot_length = "3.1",
				dot_trigger_max_distance = "3000",
				dot_tick_period = "0.5"
			}
		})
		InstantExplosiveBulletBase:on_collision(col_ray, weapon_unit, user_unit, 1)
	end
	return SawHit.super.on_collision(self, col_ray, weapon_unit, user_unit, ...)
end)