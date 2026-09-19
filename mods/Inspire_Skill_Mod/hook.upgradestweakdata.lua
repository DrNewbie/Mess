Hooks:PostHook(UpgradesTweakData, "init", "InspireSkillModUpgradesTweak", function(self)
	self.values.player.cpr_this_crew = {
		0.75
	}
	self.definitions.player_cpr_this_crew = {
		name_id = "menu_player_cpr_this_crew",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "cpr_this_crew",
			category = "player"
		}
	}
	self.values.player.long_dis_revive_mod = {
		true
	}
	self.definitions.player_long_dis_revive_mod = {
		name_id = "menu_player_long_dis_revive_mod",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "long_dis_revive_mod",
			category = "player"
		}
	}
end)