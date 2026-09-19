local mod_ids = Idstring('Crew Chief Buff'):key()
local func2 = "F_"..Idstring("func2::"..mod_ids):key()

Hooks:PostHook(UpgradesTweakData, "_player_definitions", func2, function(self)
	self.values.player.ccb_hostage_armor_multiplier = {
		1.06
	}
	self.definitions.ccb_player_hostage_armor_multiplier = {
		name_id = "menu_ccb_player_hostage_armor_multiplier",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "ccb_hostage_armor_multiplier",
			category = "player"
		}
	}
	self.values.player.ccb_intimidate_range_mul = {
		true
	}
	self.definitions.ccb_player_intimidate_range_mul = {
		name_id = "menu_player_intimidate_range_mul",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "ccb_intimidate_range_mul",
			category = "player"
		}
	}
	self.values.player.ccb_long_dis_revive_range_mul = {
		1.25
	}
	self.definitions.ccb_player_long_dis_revive_range_mul = {
		name_id = "menu_player_long_dis_revive_range_mul",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "ccb_long_dis_revive_range_mul",
			category = "player"
		}
	}
end)