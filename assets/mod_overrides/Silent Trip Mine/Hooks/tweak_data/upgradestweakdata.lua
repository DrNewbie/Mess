Hooks:PostHook(UpgradesTweakData, "_trip_mine_definitions", "SilentTripMine_trip_mine_silent_definitions", function(self)
	self.definitions.trip_mine_silent = {
		tree = 2,
		step = 4,
		category = "equipment",
		equipment_id = "trip_mine_silent",
		name_id = "debug_trip_mine_silent",
		title_id = "debug_upgrade_new_equipment",
		subtitle_id = "debug_trip_mine_silent",
		icon = "equipment_trip_mine",
		image = "upgrades_tripmines",
		image_slice = "upgrades_tripmines_slice",
		description_text_id = "trip_mine_silent",
		unlock_lvl = 0,
		prio = "high",
		slot = 1
	}
	self.definitions.trip_mine_silent_can_switch_on_off = {
		category = "feature",
		name_id = "menu_trip_mine_can_switch_on_off",
		upgrade = {
			category = "trip_mine",
			upgrade = "can_switch_on_off",
			value = 1
		}
	}
	self.definitions.trip_mine_silent_sensor_toggle = {
		category = "feature",
		name_id = "menu_trip_mine_sensor_toggle",
		upgrade = {
			category = "trip_mine",
			upgrade = "sensor_toggle",
			value = 1
		}
	}
	self.definitions.trip_mine_silent_sensor_highlight = {
		category = "feature",
		name_id = "menu_trip_mine_sensor_toggle",
		upgrade = {
			category = "trip_mine",
			upgrade = "sensor_highlight",
			value = 1
		}
	}
	self.definitions.trip_mine_silent_quantity_increase_1 = {
		category = "feature",
		name_id = "menu_trip_mine_quantity_increase_1",
		upgrade = {
			category = "trip_mine",
			upgrade = "quantity",
			value = 1
		}
	}
	self.definitions.trip_mine_silent_quantity_increase_2 = {
		category = "feature",
		name_id = "menu_trip_mine_quantity_increase_1",
		upgrade = {
			category = "trip_mine",
			upgrade = "quantity",
			value = 2
		}
	}
	self.definitions.trip_mine_silent_explosion_size_multiplier_1 = {
		category = "feature",
		incremental = true,
		name_id = "menu_trip_mine_explosion_size_multiplier",
		upgrade = {
			category = "trip_mine",
			upgrade = "explosion_size_multiplier_1",
			value = 1
		}
	}
	self.definitions.trip_mine_silent_explosion_size_multiplier_2 = {
		category = "feature",
		incremental = true,
		name_id = "menu_trip_mine_explosion_size_multiplier",
		upgrade = {
			category = "trip_mine",
			upgrade = "explosion_size_multiplier_2",
			value = 1
		}
	}
	self.definitions.trip_mine_silent_explode_timer_delay = {
		category = "feature",
		incremental = true,
		name_id = "menu_trip_mine_explode_timer_delay",
		upgrade = {
			category = "trip_mine",
			upgrade = "explode_timer_delay",
			value = 1
		}
	}
	self.definitions.trip_mine_silent_fire_trap_1 = {
		category = "feature",
		name_id = "menu_trip_mine_fire_trap",
		upgrade = {
			category = "trip_mine",
			upgrade = "fire_trap",
			value = 1
		}
	}
	self.definitions.trip_mine_silent_fire_trap_2 = {
		category = "feature",
		name_id = "menu_trip_mine_fire_trap",
		upgrade = {
			category = "trip_mine",
			upgrade = "fire_trap",
			value = 2
		}
	}
	self.definitions.trip_mine_silent_damage_multiplier_1 = {
		category = "feature",
		name_id = "menu_trip_mine_damage_multiplier",
		upgrade = {
			category = "trip_mine",
			upgrade = "damage_multiplier",
			value = 1
		}
	}
end)