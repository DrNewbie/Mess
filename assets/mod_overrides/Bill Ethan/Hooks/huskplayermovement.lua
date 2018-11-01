local locke_player_set_visual_deployable_equipment = HuskPlayerMovement.set_visual_deployable_equipment

function HuskPlayerMovement:set_visual_deployable_equipment(...)
	local char_name = managers.criminals:character_name_by_unit(self._unit)
	if not char_name then
		return
	end
	if char_name == "ecp_male" then
		return
	end
	return locke_player_set_visual_deployable_equipment(self, ...)
end