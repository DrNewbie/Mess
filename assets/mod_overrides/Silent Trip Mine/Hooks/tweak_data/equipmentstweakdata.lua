Hooks:PostHook(EquipmentsTweakData, "init", "SilentTripMine_EquipmentsTweakData", function(self)
	self.trip_mine_silent = {
		icon = "equipment_trip_mine",
		use_function_name = "use_trip_mine",
		quantity = {3, 3},
		text_id = "debug_trip_mine",
		description_id = "des_trip_mine",
		dummy_unit = "units/payday2/equipment/gen_equipment_tripmine/gen_equipment_tripmine_silent_dummy",
		deploy_time = 2,
		upgrade_deploy_time_multiplier = {
			category = "player",
			upgrade = "trip_mine_deploy_time_multiplier"
		},
		visual_object = "g_toolbag",
		upgrade_name = {
			"trip_mine",
			"shape_charge"
		}
	}
end)