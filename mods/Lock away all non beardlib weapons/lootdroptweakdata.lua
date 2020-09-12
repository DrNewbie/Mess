Hooks:PostHook(LootDropTweakData, "init", "LootDropTweakData_UnlockCustomWeapon", function(self, ...)
	self.global_values.nonbeardlib = {
		name_id = "bm_global_value_nonbeardlib",
		desc_id = "menu_l_global_value_nonbeardlib",
		unlock_id = "bm_global_value_nonbeardlib_unlock",
		color = Color(255, 255, 255, 0) / 255,
		dlc = true,
		chance = 1,
		value_multiplier = 1,
		durability_multiplier = 1,
		drops = false,
		track = true,
		sort_number = 101,
		category = "dlc"
	}
end)