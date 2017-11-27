Hooks:PostHook(UpgradesTweakData, "_player_definitions", "Armor8_player_definitions", function(self)	
	self.definitions.body_armor7 = {
		name_id = "bm_armor_level_8",
		armor_id = "level_8",
		category = "armor"
	}
end)

Hooks:PostHook(UpgradesTweakData, "_init_pd2_values", "Armor8_init_pd2_values", function(self)
	self.values.player.body_armor.armor[8] = 7
	self.values.player.body_armor.movement[8] = 1.25
	self.values.player.body_armor.concealment[8] = 21
	self.values.player.body_armor.dodge[8] = -0.15
	self.values.player.body_armor.damage_shake[8] = 0.92
	self.values.player.body_armor.stamina[8] = 1.225
	self.values.player.body_armor.skill_ammo_mul[8] = 1.04
	self.values.player.body_armor.skill_max_health_store[8] = 12.5
	self.values.player.body_armor.skill_kill_change_regenerate_speed[8] = 12.5
end)