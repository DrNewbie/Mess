local ThisModPath = ModPath
local ThisModIds = Idstring(ThisModPath):key()

Hooks:PostHook(UpgradesTweakData, "_player_definitions", "F_"..Idstring("UpgradesTweakData::"..ThisModIds):key(), function(self)
	self.values.player.yakuza_mod_armor_regen_multiplier_1 = {
		0.20
	}
	self.definitions.player_yakuza_mod_armor_regen_multiplier_1 = {
		name_id = "menu_player_yakuza_mod_armor_regen_multiplier_1",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "yakuza_mod_armor_regen_multiplier_1",
			category = "player"
		}
	}
	self.values.player.yakuza_mod_movement_speed_multiplier_1 = {
		0.20
	}
	self.definitions.player_yakuza_mod_movement_speed_multiplier_1 = {
		name_id = "menu_player_yakuza_mod_movement_speed_multiplier_1",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "yakuza_mod_movement_speed_multiplier_1",
			category = "player"
		}
	}
	self.values.player.yakuza_mod_armor_regen_health_ratio_multiplier_1 = {
		0.40
	}
	self.definitions.player_yakuza_mod_armor_regen_health_ratio_multiplier_1 = {
		name_id = "menu_player_yakuza_mod_armor_regen_health_ratio_multiplier_1",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "yakuza_mod_armor_regen_health_ratio_multiplier_1",
			category = "player"
		}
	}
	self.values.player.yakuza_mod_dodge_health_ratio_multiplier_1 = {
		0.40
	}
	self.definitions.player_yakuza_mod_dodge_health_ratio_multiplier_1 = {
		name_id = "menu_player_yakuza_mod_dodge_health_ratio_multiplier_1",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "yakuza_mod_dodge_health_ratio_multiplier_1",
			category = "player"
		}
	}
end)