Hooks:PostHook(WeaponFactoryTweakData, "init", "InstantConcussionBulletBase_TweakData", function(self)
	self.parts.wpn_fps_concussionbullet.custom_stats = {
		bullet_class = "InstantConcussionBulletBase",
		rays = 12,
		damage_far_mul = 0.1,
		damage_near_mul = 0.3,
		ammo_pickup_min_mul = 1.5,
		ammo_pickup_max_mul = 3.7
	}
end)