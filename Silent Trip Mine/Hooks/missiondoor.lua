_G.SilentTripMine = _G.SilentTripMine or {}

function MissionDoor:_check_completed_counter(type)
	if self._devices[type].completed_counter == self._devices[type].amount then
		self:_destroy_devices()
		self:trigger_sequence("door_opened")
		local sequence_name = "open_door"
		if type == "drill" then
		elseif type == "c4" then
			sequence_name = "explode_door"
			if Network:is_server() then
				if self._unit:base() then
					self._unit:base().c4 = true
				end
				if SilentTripMine:Check_Is_Silent() then
				
				else
					local alert_event = {
						"aggression",
						self._unit:position(),
						tweak_data.weapon.trip_mines.alert_radius,
						managers.groupai:state():get_unit_type_filter("civilians_enemies"),
						self._unit
					}
					managers.groupai:state():propagate_alert(alert_event)
				end
			end
		elseif type == "key" then
			sequence_name = "open_door_keycard"
		elseif type == "ecm" then
			sequence_name = "open_door_ecm"
		end
		if managers.network:session() then
			managers.network:session():send_to_peers_synched("run_mission_door_sequence", self._unit, sequence_name)
		end
		self:run_sequence_simple(sequence_name)
	end
end