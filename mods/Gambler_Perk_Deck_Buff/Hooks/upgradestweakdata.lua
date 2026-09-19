Hooks:PostHook(UpgradesTweakData, "_player_definitions", "F_"..Idstring("PostHook:UpgradesTweakData:_player_definitions:Gambler Perk Deck Buff"):key(), function(self)
	self.loose_ammo_give_team_ratio = 1
	self.loose_ammo_give_team_health_ratio = 1
	self.loose_ammo_restore_health_values = {
		base = 8,
		cd = 1,
		multiplier = 0.3,
		{0, 8},
		{8, 12},
		{12, 16}
	}
	self.values.temporary.loose_ammo_restore_health = {}
	for i, data in ipairs(self.loose_ammo_restore_health_values) do
		local base = self.loose_ammo_restore_health_values.base
		table.insert(self.values.temporary.loose_ammo_restore_health, {
			{
				base + data[1],
				base + data[2]
			},
			self.loose_ammo_restore_health_values.cd
		})
	end
	self.values.temporary.loose_ammo_give_team[1] = {
		true,
		2.5
	}
	self.values.player.loose_ammo_give_team_twice = {true}
	self.definitions.player_loose_ammo_give_team_twice = {
		name_id = "menu_player_loose_ammo_give_team_twice",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "loose_ammo_give_team_twice",
			category = "player"
		}
	}
end)