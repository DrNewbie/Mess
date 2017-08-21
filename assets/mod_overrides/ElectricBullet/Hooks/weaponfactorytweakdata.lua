Hooks:PostHook(WeaponFactoryTweakData, "init", "ElectricBulletTweakData", function(self)
	self.parts.wpn_fps_electricbullet.custom_stats = {
		bullet_class = "InstantElectricBulletBase",
		armor_piercing_add = 0,
		can_shoot_through_enemy = false, 
		can_shoot_through_shield = true, 
		can_shoot_through_wall = false,
		ammo_pickup_min_mul = 0.1,
		ammo_pickup_max_mul = 0.2
	}
end )