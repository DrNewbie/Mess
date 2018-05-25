Hooks:PostHook(WeaponFactoryTweakData, "init", "ElectricFirePoisonbulletTweakData", function(self)
	self.parts.wpn_fps_electricfirepoisonbullet.custom_stats = {
		bullet_class = "InstantElectricAltBulletBase",
		bullet_class_alt = {
			fd = "wpn_fps_electricfirepoisonbullet",
			class = {
				"FlameBulletBase",
				"PoisonBulletBase",
				"InstantElectricAltBulletBase"
			}
		},
		muzzleflash = "effects/payday2/particles/weapons/shotgun/sho_muzzleflash_dragons_breath",
		rays = 12,
		damage_far_mul = 0.1,
		damage_near_mul = 0.3,
		armor_piercing_add = 1,
		can_shoot_through_enemy = false, 
		can_shoot_through_shield = true, 
		can_shoot_through_wall = false,
		ammo_pickup_min_mul = 1.5,
		ammo_pickup_max_mul = 3.7
	}
end)