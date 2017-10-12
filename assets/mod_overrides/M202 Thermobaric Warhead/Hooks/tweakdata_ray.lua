tweak_data.projectiles.rocket_ray_frag_incen = deep_clone(tweak_data.projectiles.rocket_ray_frag)
tweak_data.projectiles.rocket_ray_frag_incen.damage = 300
tweak_data.projectiles.rocket_ray_frag_incen.projectile_trail = true
tweak_data.projectiles.rocket_ray_frag_incen.adjust_z = 0
tweak_data.projectiles.rocket_ray_frag_incen.push_at_body_index = 0
tweak_data.projectiles.rocket_ray_frag_incen.incendiary_fire_arbiter = {
	sound_event = "gl_explode",
	range = 75,
	curve_pow = 3,
	damage = 1,
	fire_alert_radius = 1500,
	alert_radius = 1500,
	sound_event_burning = "burn_loop_gen",
	player_damage = 2,
	sound_event_impact_duration = 6,
	burn_tick_period = 0.5,
	burn_duration = 10,
	effect_name = "effects/payday2/particles/explosions/molotov_grenade",
	fire_dot_data = {
		dot_trigger_chance = 35,
		dot_damage = 35,
		dot_length = 10,
		dot_trigger_max_distance = 3000,
		dot_tick_period = 0.5
	}
}
tweak_data.weapon_disable_crit_for_damage.rocket_ray_frag_incen = {explosion = false, fire = false}