local ThisModPath = ModPath

local __Name = function(__id)
	return "EPIC_"..Idstring(tostring(__id).."::"..ThisModPath):key()
end

Hooks:PostHook(NetworkPeer, "set_ip_verified", __Name("set_ip_verified"), function(self, state)
	if not Network:is_server() then
		return
	end
	DelayedCalls:Add(__Name("delay: set_ip_verified:"..self:id()), 2, function()
		if self:account_type_str() == "EPIC" then
			managers.chat:feed_system_message(1, self:name() .. " is EPIC player.")
			managers.network:session():send_to_peers("kick_peer", self:id(), 2)
			managers.network:session():on_peer_kicked(self, self:id(), 2)
		end
	end)
end)