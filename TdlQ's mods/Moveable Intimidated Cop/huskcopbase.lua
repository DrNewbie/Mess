local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

function HuskCopBase:sync_net_event(event_id)
	if event_id == 1 then
		managers.groupai:state():on_hostage_follow(managers.player:player_unit(), self._unit, true)
	elseif event_id == 2 then
		-- If the follower died:
		-- * Never seen the message sent from the server by GroupAIStateBase:on_hostage_follow(state=false)
		-- * The unit received in UnitNetworkHandler:sync_unit_event_id_16() is not alive()
		-- An OVK bug? (dead civs are handled the same, see GroupAIStateBase:on_*_unregistered)
		managers.groupai:state():on_hostage_follow(managers.player:player_unit(), self._unit, false)
	end
end
