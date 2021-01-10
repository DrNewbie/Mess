Hooks:PostHook(BlackMarketTweakData, "_init_armors", "Dr_Newbie_CustomArmourPackage_init_armors", function(self)	
	self.armors.level_9 = {
		name_id = "bm_askn_heavy_armor",
		sequence = "var_model_07",
		forced_las = "heavy_armor",
		upgrade_level = 9,
		custom = true,
        base_on = "level_7"
	}
	self:_add_desc_from_name_macro(self.armors)
end)