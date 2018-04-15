if tweak_data and tweak_data.weapon then
	tweak_data.weapon.flamethrower_mk2_crew.CLIP_AMMO_MAX = 300
	tweak_data.weapon.flamethrower_mk2_crew.NR_CLIPS_MAX = 300
	tweak_data.weapon.flamethrower_mk2_crew.DAMAGE = 5
	tweak_data.weapon.flamethrower_mk2_crew.fire_dot_data = {
		dot_trigger_chance = 101,
		dot_damage = 30,
		dot_length = 4,
		dot_trigger_max_distance = 3000,
		dot_tick_period = 0.5
	}
end