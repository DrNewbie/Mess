Hooks:PreHook(PlayerManager, "availible_equipment", "F_"..Idstring("PreHook:PlayerManager:availible_equipment:PocketMinigundozer"):key(), function(self)
	self._global.equipment["pocket_tank_mini"] = {
		tree = 2,
		step = 4,
		category = "equipment",
		equipment_id = "pocket_tank_mini",
		name_id = "debug_pocket_tank_mini",
		title_id = "debug_upgrade_new_equipment",
		subtitle_id = "debug_pocket_tank_mini",
		icon = "equipment_pocket_tank_mini",
		image = "upgrades_tripmines",
		image_slice = "upgrades_pocket_tank_mini",
		description_text_id = "pocket_tank_mini",
		unlock_lvl = 0,
		prio = "high",
		slot = 1
	}
end)