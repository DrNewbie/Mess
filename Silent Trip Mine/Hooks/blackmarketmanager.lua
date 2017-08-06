function BlackMarketManager:equip_deployable(data, loading)
	local deployable_id = data.name
	local slot = data.target_slot
	if deployable_id and not table.contains(managers.player:availible_equipment(1), deployable_id) then
		return
	end
	Global.player_manager.kit.equipment_slots[slot] = deployable_id
	if managers.menu_scene then
		managers.menu_scene:set_character_deployable(deployable_id, false, 0)
	end
	if not loading then
		MenuCallbackHandler:_update_outfit_information()
	end
	if SystemInfo:distribution() == Idstring("STEAM") then
		managers.statistics:publish_equipped_to_steam()
	end
end