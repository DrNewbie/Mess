_G.RPwith = _G.RPwith or {}

if HostNetworkSession then
	Hooks:PostHook(HostNetworkSession, 'on_peer_entered_lobby', 'F_'..Idstring('RPW:HostNetworkSessionOnPeerEnteredLobby'):key(), function(self, peer)
		local peer_id = peer:id()
		DelayedCalls:Add('DelayedModRPwithX_' .. tostring(peer_id), 1, function()
			RPwith:Record_History(peer_id)
		end)
	end)

	Hooks:PostHook(HostNetworkSession, 'on_peer_sync_complete', 'F_'..Idstring('RPW:HostNetworkSessionOnPeerSyncComplete'):key(), function(self, peer, peer_id)
		DelayedCalls:Add('DelayedModRPwithY_' .. tostring(peer_id), 1, function()
			RPwith:Record_History(peer_id)
		end)
	end)
end

if ClientNetworkSession then
	Hooks:PostHook(ClientNetworkSession, 'on_entered_lobby', 'F_'..Idstring('RPW:ClientNetworkSessionOnEnteredLobby'):key(), function(self)
		RPwith:Record_All()
	end)

	Hooks:PostHook(ClientNetworkSession, 'on_load_complete', 'F_'..Idstring('RPW:ClientNetworkSessionOnLoadComplete'):key(), function(self, simulation)
		RPwith:Record_All()
	end)
end