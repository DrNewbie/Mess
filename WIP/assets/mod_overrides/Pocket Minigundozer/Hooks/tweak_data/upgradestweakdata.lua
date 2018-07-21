Hooks:PostHook(UpgradesTweakData, "_trip_mine_definitions", "PocketMinigundozer_pocket_tank_mini_definitions", function(self)
	self.definitions.pocket_tank_mini = {
		tree = 2,
		step = 4,
		category = "equipment",
		equipment_id = "pocket_tank_mini",
		name_id = "debug_pocket_tank_mini",
		title_id = "debug_upgrade_new_equipment",
		subtitle_id = "debug_pocket_tank_mini",
		icon = "equipment_pocket_tank_mini",
		image = "upgrades_tripmines",
		image_slice = "upgrades_tripmines_slice",
		description_text_id = "pocket_tank_mini",
		unlock_lvl = 0,
		prio = "high",
		slot = 1
	}
end)