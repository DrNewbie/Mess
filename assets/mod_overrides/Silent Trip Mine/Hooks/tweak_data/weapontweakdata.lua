Hooks:PreHook(WeaponTweakData, "_init_data_player_weapons", "SilentTripMine_init_data_player_weapons", function(self)
	self.trip_mine_silent = {}
	self.trip_mine_silent.delay = 0.3
	self.trip_mine_silent.damage = 100
	self.trip_mine_silent.player_damage = 6
	self.trip_mine_silent.damage_size = 300
	self.trip_mine_silent.alert_radius = 1
end)