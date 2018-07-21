Hooks:PostHook(EquipmentsTweakData, "init", "PocketMinigundozer_EquipmentsTweakData", function(self)
	self.pocket_tank_mini = {
		dummy_unit = "units/payday2/equipment/gen_equipment_tripmine/gen_equipment_pocket_tank_mini_dummy",
		text_id = "bm_equipment_pocket_tank_mini",
		deploy_time = 2,
		visual_object = "g_toolbag",
		icon = "equipment_pocket_tank_mini",
		description_id = "pocket_tank_mini",
		use_function_name = "use_pocket_tank_mini",
		quantity = {1},
		upgrade_name = {},
		upgrade_deploy_time_multiplier = {
			category = "player",
			upgrade = "trip_mine_deploy_time_multiplier"
		}
	}
end)