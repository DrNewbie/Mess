Hooks:PostHook(UpgradesTweakData, "_player_definitions", "CriticalPerkDeckTierInit", function(self)
	self.values.player.passive_critical_to_all = {true}
	self.definitions.player_critical_to_all = {
		name_id = "player_critical_to_all",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "passive_critical_to_all",
			category = "player"
		}
	}
	self.values.player.passive_additional_surprise_1 = {0.3}
	self.definitions.player_critical_tier_1 = {
		name_id = "player_additional_surprise_1",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "passive_additional_surprise_1",
			category = "player"
		}
	}
	self.values.player.passive_additional_surprise_2 = {0.3}
	self.definitions.player_critical_tier_2 = {
		name_id = "player_additional_surprise_2",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "passive_additional_surprise_2",
			category = "player"
		}
	}
	self.values.player.passive_critical_gain_health_1 = {8}
	self.definitions.player_critical_gain_health_1 = {
		name_id = "player_critical_gain_health_1",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "passive_critical_gain_health_1",
			category = "player"
		}
	}
	self.values.player.passive_critical_gain_health_2 = {4}
	self.definitions.player_critical_gain_health_2 = {
		name_id = "player_critical_gain_health_2",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "passive_critical_gain_health_2",
			category = "player"
		}
	}
	self.values.weapon.passive_ct_reload_speed_multiplier_1 = {-0.3}
	self.definitions.player_ct_reload_speed_multiplier_1 = {
		name_id = "player_ct_reload_speed_multiplier_1",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "passive_ct_reload_speed_multiplier_1",
			category = "weapon"
		}
	}
	self.values.weapon.passive_ct_reload_speed_multiplier_2 = {-0.3}
	self.definitions.player_ct_reload_speed_multiplier_2 = {
		name_id = "player_ct_reload_speed_multiplier_2",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "passive_ct_reload_speed_multiplier_2",
			category = "weapon"
		}
	}
end)