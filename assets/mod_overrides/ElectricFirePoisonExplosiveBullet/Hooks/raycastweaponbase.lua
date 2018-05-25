local bullet_class_alt_FlameBullet_give_fire_damage = FlameBulletBase.give_fire_damage

function FlameBulletBase:give_fire_damage(col_ray, weapon_unit, user_unit, damage, armor_piercing)
	if weapon_unit.base and weapon_unit:base()._ammo_data and weapon_unit:base()._ammo_data.bullet_class and weapon_unit:base()._ammo_data.bullet_class_alt then
		if weapon_unit:base()._ammo_data.bullet_class_alt.fd == "wpn_fps_electricfirepoisonexplosivebullet" then
			local action_data = {
				variant = "fire",
				damage = damage,
				weapon_unit = weapon_unit,
				attacker_unit = user_unit,
				col_ray = col_ray,
				armor_piercing = armor_piercing,
				fire_dot_data = {
					dot_trigger_chance = "100",
					dot_damage = "10",
					dot_length = "3.1",
					dot_trigger_max_distance = "3000",
					dot_tick_period = "0.5"
				}
			}
			return col_ray.unit:character_damage():damage_fire(action_data)
		end
	end
	return bullet_class_alt_FlameBullet_give_fire_damage(self, col_ray, weapon_unit, user_unit, damage, armor_piercing)
end