Hooks:PostHook(NewRaycastWeaponBase, '_update_stats_values', 'F_'..Idstring('PostHook:NewRaycastWeaponBase:_update_stats_values:Expanding Bullet (Weapon Mod)'):key(), function(self)
	if table.contains(self._blueprint, "wpn_fps_dd_expanding_bullet") then
		self._can_shoot_through_shield = false
		self._can_shoot_through_enemy = false
		self._can_shoot_through_wall = false
		self._armor_piercing_chance = 0
		self.__wpn_fps_dd_expanding_bullet = true
	end
end)