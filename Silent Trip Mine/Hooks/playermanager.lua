function PlayerManager:availible_equipment(slot)
	local equipment = {}
	self._global.equipment["trip_mine_silent"] = {
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
	for name, data in pairs(self._global.equipment) do
		if not slot or slot and tweak_data.upgrades.definitions[name].slot == slot then
			table.insert(equipment, name)
		end
	end
	return equipment
end