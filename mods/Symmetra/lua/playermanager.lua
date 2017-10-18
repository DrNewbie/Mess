function PlayerManager:check_selected_equipment_placement_valid(player)
	local equipment_data = managers.player:selected_equipment()

	if not equipment_data then
		return false
	end

	if equipment_data.equipment == "sentry_gun_silent" or equipment_data.equipment == "sentry_gun" or equipment_data.equipment == "trip_mine" or equipment_data.equipment == "ecm_jammer" then
		return player:equipment():valid_look_at_placement(tweak_data.equipments[equipment_data.equipment]) and true or false
	elseif equipment_data.equipment == "ammo_bag" or equipment_data.equipment == "doctor_bag" or equipment_data.equipment == "first_aid_kit" or equipment_data.equipment == "bodybags_bag" then
		return player:equipment():valid_shape_placement(equipment_data.equipment, tweak_data.equipments[equipment_data.equipment]) and true or false
	elseif equipment_data.equipment == "armor_kit" then
		return true
	end

	return player:equipment():valid_placement(tweak_data.equipments[equipment_data.equipment]) and true or false
end