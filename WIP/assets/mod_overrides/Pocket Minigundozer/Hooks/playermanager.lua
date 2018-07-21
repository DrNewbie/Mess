function PlayerManager:availible_equipment(slot)
	local equipment = {}
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
	for name, data in pairs(self._global.equipment) do
		if not slot or slot and tweak_data.upgrades.definitions[name].slot == slot then
			table.insert(equipment, name)
		end
	end
	return equipment
end