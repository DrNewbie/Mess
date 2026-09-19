if Network:is_client() then
	return
end

function MissionDoorDeviceInteractionExt:interact(player)
	if not self:can_interact(player) then
		return
	end
	MissionDoorDeviceInteractionExt.super.super.interact(self, player)
	if Network:is_client() then
		managers.network:session():send_to_host("server_place_mission_door_device", self._unit, player)
	else
		local result = self:server_place_mission_door_device(player)
		local is_drill = self._unit and alive(self._unit) and self._unit:base() and self._unit:base().is_drill
		if is_drill and result == false then
			local _drill = self._unit
			local player_drill_upgrades = Drill.get_upgrades(_drill, nil)
			if player_drill_upgrades and _drill:base():compare_skill_upgrades(player_drill_upgrades) then
				return
			end
			if _drill:interaction():active() or _drill:base()._jammed then
				return
			end
			_drill:timer_gui()._update_enabled = false
			_drill:base():destroy()
			_drill:set_slot(0)
		end
	end
end