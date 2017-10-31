if Network:is_client() then
	return
end

_G.ShadowRaidLoud = _G.ShadowRaidLoud or {}

Hooks:Add("NetworkManagerOnPeerAdded", "NetworkManagerOnPeerAdded_ModAnnounce", function(peer, peer_id)
	if Network:is_server() then
		DelayedCalls:Add("DelayedModAnnounces" .. tostring(peer_id), 10, function()
			local message = ShadowRaidLoud.Message2OtherPlayers
			local peer2 = managers.network:session() and managers.network:session():peer(peer_id)
			if peer2 and ShadowRaidLoud and ShadowRaidLoud.Enable then
				peer2:send("send_chat_message", ChatManager.GAME, message)
			end
		end)
	end
end)