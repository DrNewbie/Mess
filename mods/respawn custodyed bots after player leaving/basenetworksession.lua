Hooks:PostHook(BaseNetworkSession, "remove_peer", "OnPeerRemoveEventRunBotRespawn", function()
	if not managers.criminals or not managers.trade or not Network or not Network:is_server() then
	
	else 
		managers.trade:try_respawn_one_ai_online()
	end	
end)