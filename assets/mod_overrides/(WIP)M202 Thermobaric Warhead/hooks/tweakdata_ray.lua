Hooks:PostHook( TweakData, "init", "M202IncenInit", function(self)
	self.projectiles.launcher_m203 = {
		name_id = "bm_rocket_frag",
		unit = "units/pd2_dlc_overkill_pack/weapons/wpn_third_rpg7_fired_rocket/wpn_third_rpg7_fired_rocket",
		weapon_id = "rpg7",
		no_cheat_count = true,
		impact_detonation = true,
		is_explosive = true,
		time_cheat = 1,
		physic_effect = Idstring("physic_effects/anti_gravitate"),
		adjust_z = 0
	}
	self.projectiles.rocket_ray_frag.fire_dot_data = {
		dot_trigger_chance = 35,
		dot_damage = 1,
		dot_length = 3,
		dot_trigger_max_distance = 3000,
		dot_tick_period = 0.5
	}
	self.projectiles.rocket_ray_frag.range = 75
	self.projectiles.rocket_ray_frag.burn_duration = 10
	self.projectiles.rocket_ray_frag.burn_tick_period = 0.5
	self.projectiles.rocket_ray_frag.alert_radius = 1500
	self.projectiles.rocket_ray_frag.fire_alert_radius = 1500
end)