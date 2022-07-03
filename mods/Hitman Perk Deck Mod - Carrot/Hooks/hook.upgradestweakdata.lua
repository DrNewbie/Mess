local ThisModPath = ModPath
local ThisModIds = Idstring(ThisModPath):key()

Hooks:PostHook(UpgradesTweakData, "_player_definitions", "F_"..Idstring("UpgradesTweakData::"..ThisModIds):key(), function(self)
	self.values.player.addition_more_ammo_hitman_mod = {
		0.25
	}
	self.definitions.player_addition_more_ammo_hitman_mod = {
		name_id = "menu_player_addition_more_ammo_hitman_mod",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "addition_more_ammo_hitman_mod",
			category = "player"
		}
	}
	self.values.player.addition_ammo_pickup_hitman_mod = {
		0.25
	}
	self.definitions.player_addition_ammo_pickup_hitman_mod = {
		name_id = "menu_player_addition_ammo_pickup_hitman_mod",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "addition_ammo_pickup_hitman_mod",
			category = "player"
		}
	}
	self.values.player.guaranteed_armor_regen_hitman_mod = {
		2.5
	}
	self.definitions.player_guaranteed_armor_regen_hitman_mod = {
		name_id = "menu_player_guaranteed_armor_regen_hitman_mod",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "guaranteed_armor_regen_hitman_mod",
			category = "player"
		}
	}
end)