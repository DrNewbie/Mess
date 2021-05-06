Hooks:PostHook(NetworkPeer, "set_ip_verified", "F_"..Idstring("BlackList::set_ip_verified"):key(), function(self, state)
	DelayedCalls:Add("D_"..Idstring("BlackList::set_ip_verified"):key(), 2, function()
		local user = Steam:user(self:ip())
		if user and user:rich_presence("is_modded") == "1" or self:is_modded() then
			managers.chat:feed_system_message(1, self:name() .. " Has mods")
			for i, mod in ipairs(self:synced_mods()) do
				local mod_mini = string.lower(mod.name)	
				local kick_on = {
					"Better Cheater Kicker"
				}
				for _, v in pairs(kick_on) do
					if mod_mini == string.lower(v) then
						local identifier = "cheater_banned_" .. tostring(self:id())
						managers.ban_list:ban(identifier, self:name())
						managers.chat:feed_system_message(1, self:name() .. " Got kicked for using mod: " .. mod.name)
						local message_id = 0
						message_id = 6
						managers.network:session():send_to_peers("kick_peer", self:id(), message_id)
						managers.network:session():on_peer_kicked(self, self:id(), message_id)
						return
					end
				end
			end
		end
	end)
end)