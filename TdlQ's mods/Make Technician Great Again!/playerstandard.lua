local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local mtga_original_playerstandard_startactioninteract = PlayerStandard._start_action_interact
function PlayerStandard:_start_action_interact(t, input, timer, interact_object)
	if interact_object:interaction().tweak_data == 'drill_tank' then
		local session = managers.network:session()
		local original_send_to_peers_synched = session.send_to_peers_synched
		session.send_to_peers_synched = session.mtga_send_to_peers_synched
		mtga_original_playerstandard_startactioninteract(self, t, input, timer, interact_object)
		session.send_to_peers_synched = original_send_to_peers_synched
	else
		mtga_original_playerstandard_startactioninteract(self, t, input, timer, interact_object)
	end
end

local mtga_original_playerstandard_interuptactioninteract = PlayerStandard._interupt_action_interact
function PlayerStandard:_interupt_action_interact(...)
	if self._interact_params and self._interact_params.tweak_data == 'drill_tank' then
		local session = managers.network:session()
		local original_send_to_peers_synched = session.send_to_peers_synched
		session.send_to_peers_synched = session.mtga_send_to_peers_synched
		mtga_original_playerstandard_interuptactioninteract(self, ...)
		session.send_to_peers_synched = original_send_to_peers_synched
	else
		mtga_original_playerstandard_interuptactioninteract(self, ...)
	end
end
