local mod_ids = Idstring('Crew Chief Buff'):key()
local func2 = "F_"..Idstring("func2::"..mod_ids):key()

Hooks:PostHook(UpgradesTweakData, "_player_definitions", func2, function(self)
	self.values.team.armor.hostage_multiplier = {
		1.06
	}
	self.definitions.team_hostage_armor_multiplier = {
		name_id = "menu_team_hostage_armor_multiplier",
		category = "team",
		upgrade = {
			value = 1,
			upgrade = "hostage_multiplier",
			category = "armor"
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
end)