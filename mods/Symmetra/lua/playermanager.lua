local old_func = "F_"..Idstring("Symmetra:check_equipment_placement_valid"):key()

PlayerManager[old_func] = PlayerManager[old_func] or PlayerManager.check_equipment_placement_valid

function PlayerManager:check_equipment_placement_valid(player, equipment, ...)
	local equipment_data = managers.player:equipment_data_by_name(equipment)
	if not equipment_data then
		return false
	end
	if equipment_data.equipment == "sentry_gun_silent" or equipment_data.equipment == "sentry_gun" then
		return player:equipment():valid_look_at_placement(tweak_data.equipments[equipment_data.equipment]) and true or false
	end
	return self[old_func](self, player, equipment, ...)
end