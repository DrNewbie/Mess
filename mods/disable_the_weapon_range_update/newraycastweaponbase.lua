Hooks:PostHook(NewRaycastWeaponBase, "_update_stats_values", "F_"..Idstring("Disable the weapon range update:NewRaycastWeaponBase:_update_stats_values"):key(), function(self)
	self._optimal_distance = 0
	self._optimal_range = 0
end)