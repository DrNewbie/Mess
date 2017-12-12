Hooks:PostHook(UpgradesTweakData, "_player_definitions", "FullyChargedPerkDeckTierInit", function(self)
	self.values.player.passive_fully_charged_armor2damage = {true}
	self.definitions.player_fully_charged_armor2damage = {
		name_id = "player_fully_charged_armor2damage",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "passive_fully_charged_armor2damage",
			category = "player"
		}
	}
	self.values.player.passive_fully_charged_invulnerable = {1}
	self.definitions.player_fully_charged_invulnerable = {
		name_id = "player_fully_charged_invulnerable",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "passive_fully_charged_invulnerable",
			category = "player"
		}
	}
	self.values.player.passive_fully_charged_far2damage = {true}
	self.definitions.player_fully_charged_far2damage = {
		name_id = "player_fully_charged_far2damage",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "passive_fully_charged_far2damage",
			category = "player"
		}
	}
	self.values.player.passive_fully_charged_explosive_headshot_1 = {100}
	self.definitions.player_fully_charged_explosive_headshot_1 = {
		name_id = "player_fully_charged_explosive_headshot_1",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "passive_fully_charged_explosive_headshot_1",
			category = "player"
		}
	}
	self.values.player.passive_fully_charged_explosive_headshot_2 = {500}
	self.definitions.player_fully_charged_explosive_headshot_2 = {
		name_id = "player_fully_charged_explosive_headshot_2",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "passive_fully_charged_explosive_headshot_2",
			category = "player"
		}
	}
	self.values.player.passive_fully_charged_headshot_ony = {true}
	self.definitions.player_fully_charged_headshot_ony = {
		name_id = "player_fully_charged_headshot_ony",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "passive_fully_charged_headshot_ony",
			category = "player"
		}
	}
	self.values.player.passive_fully_charged_time2damage = {true}
	self.definitions.player_fully_charged_time2damage = {
		name_id = "player_fully_charged_time2damage",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "passive_fully_charged_time2damage",
			category = "player"
		}
	}
end)