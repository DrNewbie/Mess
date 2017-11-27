Hooks:PostHook(BlackMarketTweakData, "_init_armors", "Armor8_init_armors", function(self)	
	self.armors.level_8 = {
		name_id = "bm_armor_level_8",
		sequence = "var_model_08",
		upgrade_level = 8
	}
	self:_add_desc_from_name_macro(self.armors)
end)