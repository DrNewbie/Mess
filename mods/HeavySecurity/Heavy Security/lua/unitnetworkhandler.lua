_G.HeavySecurity = _G.HeavySecurity or {}

if Network:is_client() then
	return
end

if not HeavySecurity then
	return
end

Hooks:Add("NetworkManagerOnPeerAdded", "NetworkManagerOnPeerAdded_ModAnnounce", function(peer, peer_id)
	if Network:is_server() then
		DelayedCalls:Add("DelayedModAnnounces_HeavySecurity_" .. tostring(peer_id), 5, function()
			local peer2 = managers.network:session() and managers.network:session():peer(peer_id)
			if peer2 then
				peer2:send("send_chat_message", ChatManager.GAME, "This lobby is running Heavy Security MOD.")
			end
		end)
	end
end)