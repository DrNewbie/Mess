Hooks:PostHook(UpgradesTweakData, "_player_definitions", "F_"..Idstring("PostHook:UpgradesTweakData:_player_definitions:Infiltrator Perk Deck Buff"):key(), function(self)
	self.values.player.infiltrator_damage_dampener_bonus = {1.5}
	self.definitions.player_infiltrator_damage_dampener_bonus = {
		name_id = "menu_player_infiltrator_damage_dampener_bonus",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "infiltrator_damage_dampener_bonus",
			category = "player"
		}
	}
	self.values.player.infiltrator_damage_dampener_bonus_cd = {1.5}
	self.definitions.player_infiltrator_damage_dampener_bonus_cd = {
		name_id = "menu_player_infiltrator_damage_dampener_bonus_cd",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "infiltrator_damage_dampener_bonus_cd",
			category = "player"
		}
	}
end)