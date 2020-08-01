Hooks:PostHook(NetworkPeer, "set_ip_verified", "F_"..Idstring("NoKickerIguessOwO"):key(), function(self)
	if Network and Network:is_server() then
		DelayedCalls:Add( "D_"..Idstring("NoKickerIguessOwO"..tostring(self)):key(), 2 + math.random(), function()
			local user = Steam:user(self:ip())
			if user and user:rich_presence("is_modded") == "1" or self:is_modded() then
				local is_kick
				for _, mod in pairs(self:synced_mods()) do
					if type(mod) == "table" and string.lower(tostring(mod.name)):find("kick") then
						is_kick = true
						break
					end
				end
				if is_kick then
					managers.network:session():send_to_peers("kick_peer", self:id(), 6)
					managers.network:session():on_peer_kicked(self, self:id(), 6)
				end
			end
		end)
	end
end)