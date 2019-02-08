function GroupAIStateBase:convert_hostage_to_criminal_new(unit, peer_unit)
	local player_unit = peer_unit or managers.player:player_unit()
	if not alive(player_unit) or not self._criminals[player_unit:key()] then
		return
	end
	if not alive(unit) then
		return
	end
	local u_key = unit:key()
	local u_data = self._police[u_key]
	if not u_data then
		return
	end
	self:set_enemy_assigned(nil, u_key)
	unit:brain():convert_to_criminal(peer_unit)
	unit:contour():add("friendly")
	unit:contour()._remove = function()
		return
	end
	self:_set_converted_police(u_key, unit, player_unit)
	unit:movement():set_team(self._teams.converted_enemy)
end