Hooks:PostHook(NetworkPeer, "set_ip_verified", "NoFriendKickerIguessOwO", function(self)
	if Network and Network:is_server() and Steam:logged_on() and Steam:friends() then
		DelayedCalls:Add( "D_"..Idstring("NoFriendKickerIguessOwO"..tostring(self)):key(), 2 + math.random(), function()
			local user = Steam:user(self:ip())
			if user then
				local is_kick
				for _, friend in ipairs(Steam:friends()) do
					if friend:user_id() == self:user_id() then
						is_kick = true
						break
					end
				end
				if not is_kick then
					managers.network:session():send_to_peers("kick_peer", self:id(), 6)
					managers.network:session():on_peer_kicked(self, self:id(), 6)
				end
			end
		end)
	end
end)