if RequiredScript == "lib/network/handlers/unitnetworkhandler" then
	Hooks:Add("NetworkManagerOnPeerAdded", "F_"..Idstring("NetworkManagerOnPeerAdded_BlackList"):key(), function(peer, peer_id)
		if Network:is_server() and BlackList then
			DelayedCalls:Add("DelayedMod"..tostring(peer_id).."F_"..Idstring("NetworkManagerOnPeerAdded_BlackList"):key(), 1, function()
				if peer then
					local __user_id = tostring(peer:user_id())
					if tostring(__user_id) == "76561198000740000" then
						managers.network:session():on_peer_kicked(peer, peer:id(), 0)
						managers.network:session():send_to_peers("kick_peer", peer:id(), 2)
					end
				end
			end)
		end
	end)
end
if RequiredScript == "lib/network/matchmaking/networkmatchmakingsteam" then
	local old_is_server_ok = NetworkMatchMakingSTEAM.is_server_ok
	function NetworkMatchMakingSTEAM:is_server_ok(friends_only, room, ...)
		if tostring(room) == "76561198000740000" then
			return false
		end
		return old_is_server_ok(self, friends_only, room, ...)
	end
end