_G.NGBTOwO = _G.NGBTOwO or {}

if HostNetworkSession then
	Hooks:PostHook(HostNetworkSession, 'on_peer_entered_lobby', 'F_'..Idstring('NGBTOwO:HostNetworkSessionOnPeerEnteredLobby'):key(), function(self, peer)
		local peer_id = peer:id()
		DelayedCalls:Add('DelayedModNGBTOwOX_' .. tostring(peer_id), 1, function()
			NGBTOwO:Check(peer_id)
		end)
	end)
end

if ClientNetworkSession then
	Hooks:PostHook(ClientNetworkSession, 'on_entered_lobby', 'F_'..Idstring('NGBTOwO:ClientNetworkSessionOnEnteredLobby'):key(), function(self)
		DelayedCalls:Add('DelayedModNGBTOwOW_', 3, function()
			NGBTOwO:Check_All()
		end)
	end)
	Hooks:PostHook(ClientNetworkSession, 'on_load_complete', 'F_'..Idstring('NGBTOwO:ClientNetworkSessionOnLoadComplete'):key(), function(self)
		DelayedCalls:Add('DelayedModNGBTOwOZ_', 3, function()
			NGBTOwO:Check_All()
		end)
	end)
end

if NetworkPeer then
	Hooks:PostHook(NetworkPeer, "set_ip_verified", 'F_'..Idstring('NGBTOwO:PostHook:NetworkPeer:set_ip_verified'):key(), function(self)
		if self and self.id then
			local peer_id = self:id()
			DelayedCalls:Add('DelayedModNGBTOwOY_' .. tostring(peer_id), 1, function()
				NGBTOwO:Check(peer_id)
			end)
		end
	end)
end