if Network:is_client() then
	return
end

_G.SurvivorModeBase = _G.SurvivorModeBase or {}

Hooks:Add("NetworkManagerOnPeerAdded", "NetworkManagerOnPeerAdded_ModAnnounce", function(peer, peer_id)
	if Network:is_server() then
		DelayedCalls:Add("DelayedModAnnounces" .. tostring(peer_id), 10, function()
			local message = "This lobby is running 'Survivor Mode', if you don't know what is this, please ask host or leave here."
			local peer2 = managers.network:session() and managers.network:session():peer(peer_id)
			if peer2 then
				peer2:send("send_chat_message", ChatManager.GAME, message)
			end
			SurvivorModeBase:Load_Package()
			DelayedCalls:Add("DelayedModReload", 10, function()
				managers.game_play_central:restart_the_game()
			end)
		end)
	end
end)