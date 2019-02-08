Hooks:PreHook(WeaponTweakData, "_init_data_player_weapons", "PocketMinigundozer_init_data_player_weapons", function(self)
	self.pocket_tank_mini = {}
	self.pocket_tank_mini.delay = 0.3
	self.pocket_tank_mini.damage = 1
	self.pocket_tank_mini.player_damage = 1
	self.pocket_tank_mini.damage_size = 1
	self.pocket_tank_mini.alert_radius = 1
end)