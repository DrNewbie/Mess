local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local gcw_original_basenetworksession_onpeersynccomplete = BaseNetworkSession.on_peer_sync_complete
function BaseNetworkSession:on_peer_sync_complete(peer, peer_id)
	gcw_original_basenetworksession_onpeersynccomplete(self, peer, peer_id)

	local hud = managers.hud
	if hud and hud._hud and hud._hud.waypoints then
		local waypoint = hud._hud.waypoints['CustomWaypoint_localplayer']
		if waypoint then
			if waypoint.position then
				LuaNetworking:SendToPeer(peer_id, CustomWaypoints.network.place_waypoint, Vector3.ToString(waypoint.position))
			elseif waypoint.unit then
				LuaNetworking:SendToPeer(peer_id, CustomWaypoints.network.attach_waypoint, tostring(waypoint.unit:id()))
			end
		end
	end
end

Hooks:Add('BaseNetworkSessionOnPeerRemoved', 'BaseNetworkSessionOnPeerRemoved_CustomWaypoints', function(peer, peer_id, reason)
	CustomWaypoints:NetworkRemove(peer_id)
end)

Hooks:Add('NetworkReceivedData', 'NetworkReceivedData_CustomWaypoints', function(sender, messageType, data)
	if messageType == CustomWaypoints.network.place_waypoint then
		CustomWaypoints:NetworkPlace(sender, data)
	end

	if messageType == CustomWaypoints.network.attach_waypoint then
		CustomWaypoints:NetworkAttach(sender, data)
	end

	if messageType == CustomWaypoints.network.remove_waypoint then
		CustomWaypoints:NetworkRemove(sender)
	end
end)
