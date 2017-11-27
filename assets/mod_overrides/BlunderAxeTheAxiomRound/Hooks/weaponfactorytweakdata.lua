Hooks:PostHook(WeaponFactoryTweakData, "init", "BlunderAxeTheAxiomRoundTweakData", function(self)
	self.parts.wpn_fps_axebullet.custom_stats = {
		armor_piercing_add = 0,
		can_shoot_through_enemy = false, 
		can_shoot_through_shield = true, 
		can_shoot_through_wall = false,
		ammo_pickup_min_mul = 0.5,
		ammo_pickup_max_mul = 0.9
	}
end )