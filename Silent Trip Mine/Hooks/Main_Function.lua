_G.SilentTripMine = _G.SilentTripMine or {}

function SilentTripMine:Check_Is_Silent()
	local equipment_data = managers.player and managers.player:selected_equipment() or nil
	if equipment_data and equipment_data.equipment and equipment_data.equipment == "trip_mine_silent" then
		return true
	end
	return false
end