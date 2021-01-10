Hooks:PostHook(UpgradesTweakData, "_player_definitions", "Dr_Newbie_CustomArmourPackage_player_definitions", function(self)	
	self.definitions.body_armor8 = {
		name_id = "bm_armor_level_9",
		armor_id = "level_9",
		category = "armor"
	}
end)

Hooks:PostHook(UpgradesTweakData, "_init_pd2_values", "Dr_Newbie_CustomArmourPackage_init_pd2_values", function(self)
	self.values.player.body_armor.armor[9] = self.values.player.body_armor.armor[7] * 2
	self.values.player.body_armor.movement[9] = self.values.player.body_armor.movement[7] * 0.5
	self.values.player.body_armor.concealment[9] = self.values.player.body_armor.concealment[7] * 0.1
	self.values.player.body_armor.dodge[9] = self.values.player.body_armor.dodge[7] * 2
	self.values.player.body_armor.damage_shake[9] = self.values.player.body_armor.damage_shake[7]
	self.values.player.body_armor.stamina[9] = self.values.player.body_armor.stamina[7]
	self.values.player.body_armor.skill_ammo_mul[9] = self.values.player.body_armor.skill_ammo_mul[7]
	self.values.player.body_armor.skill_max_health_store[9] = self.values.player.body_armor.skill_max_health_store[7]
	self.values.player.body_armor.skill_kill_change_regenerate_speed[9] = self.values.player.body_armor.skill_kill_change_regenerate_speed[7]
	self.values.player.armor_grinding[1][9] = self.values.player.armor_grinding[1][7]
	self.values.player.damage_to_armor[1][9] = self.values.player.damage_to_armor[1][7]
end)