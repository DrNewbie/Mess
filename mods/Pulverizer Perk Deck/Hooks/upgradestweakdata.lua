Hooks:PostHook(UpgradesTweakData, "_player_definitions", "PulverizerPerkDeckTierInit", function(self)
	self.values.player.passive_pulverizer_melee_event = {true}
	self.definitions.player_pulverizer_melee_event = {
		name_id = "player_pulverizer_melee_event",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "passive_pulverizer_melee_event",
			category = "player"
		}
	}
	self.values.player.passive_pulverizer_reduce_melee_charge = {0.25}
	self.definitions.player_pulverizer_reduce_melee_charge = {
		name_id = "player_pulverizer_reduce_melee_charge",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "passive_pulverizer_reduce_melee_charge",
			category = "player"
		}
	}
	self.values.player.passive_pulverizer_reduce_melee_delay = {0.75}
	self.definitions.player_pulverizer_reduce_melee_delay = {
		name_id = "player_pulverizer_reduce_melee_delay",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "passive_pulverizer_reduce_melee_delay",
			category = "player"
		}
	}
	self.values.player.passive_pulverizer_run_and_punch = {3.0}
	self.definitions.player_pulverizer_run_and_punch = {
		name_id = "player_pulverizer_run_and_punch",
		category = "feature",		
		upgrade = {
			value = 1,
			upgrade = "passive_pulverizer_run_and_punch",
			category = "player"
		}
	}
	self.values.player.passive_pulverizer_health_regen = {0.01}
	self.definitions.player_pulverizer_health_regen = {
		name_id = "player_pulverizer_health_regen",
		category = "feature",		
		upgrade = {
			value = 1,
			upgrade = "passive_pulverizer_health_regen",
			category = "player"
		}
	}
	self.values.player.passive_pulverizer_armor_regen = {3}
	self.definitions.player_pulverizer_armor_regen = {
		name_id = "player_pulverizer_armor_regen",
		category = "feature",		
		upgrade = {
			value = 1,
			upgrade = "passive_pulverizer_armor_regen",
			category = "player"
		}
	}
	self.values.player.passive_pulverizer_damage_stack = {0.25}
	self.definitions.player_pulverizer_damage_stack = {
		name_id = "player_pulverizer_damage_stack",
		category = "feature",		
		upgrade = {
			value = 1,
			upgrade = "passive_pulverizer_damage_stack",
			category = "player"
		}
	}
	self.values.player.passive_pulverizer_loss_ammo = {
		0.75,
		0.50,
		0.35,
		0.20,
		0.05
	}
	self.definitions.player_pulverizer_loss_ammo_1 = {
		name_id = "player_pulverizer_loss_ammo_1",
		category = "feature",		
		upgrade = {
			value = 1,
			upgrade = "passive_pulverizer_loss_ammo",
			category = "player"
		}
	}
	self.definitions.player_pulverizer_loss_ammo_2 = {
		name_id = "player_pulverizer_loss_ammo_2",
		category = "feature",		
		upgrade = {
			value = 2,
			upgrade = "passive_pulverizer_loss_ammo",
			category = "player"
		}
	}
	self.definitions.player_pulverizer_loss_ammo_3 = {
		name_id = "player_pulverizer_loss_ammo_3",
		category = "feature",		
		upgrade = {
			value = 3,
			upgrade = "passive_pulverizer_loss_ammo",
			category = "player"
		}
	}
	self.definitions.player_pulverizer_loss_ammo_4 = {
		name_id = "player_pulverizer_loss_ammo_4",
		category = "feature",		
		upgrade = {
			value = 4,
			upgrade = "passive_pulverizer_loss_ammo",
			category = "player"
		}
	}
	self.definitions.player_pulverizer_loss_ammo_5 = {
		name_id = "player_pulverizer_loss_ammo_5",
		category = "feature",		
		upgrade = {
			value = 5,
			upgrade = "passive_pulverizer_loss_ammo",
			category = "player"
		}
	}
end)