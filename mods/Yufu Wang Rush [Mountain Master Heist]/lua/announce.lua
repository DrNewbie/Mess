local function __DoAnnounce(peer_id)
	if not peer_id or peer_id == 1 or Global.game_settings.level_id ~= "pent" then
		return
	end
	for i = 1, 3 do
		DelayedCalls:Add("yufuwangrushloldelayedcalls"..tostring(peer_id), 3*i, function()
			local peer_an = managers.network:session() and managers.network:session():peer(peer_id)
			if peer_an then
				peer_an:send("send_chat_message", ChatManager.GAME, "I'm using [ Yufu Wang Rush ] ( https://modworkshop.net/mod/36657 )")
			end
		end)
	end
end

Hooks:PostHook(HostNetworkSession, "chk_drop_in_peer", "yufuwangrushlolpeer1", function(self, peer)
	__DoAnnounce(peer:id())
end)

Hooks:PostHook(HostNetworkSession, "on_peer_outfit_loaded", "yufuwangrushlolpeer2", function(self, peer)
	__DoAnnounce(peer:id())
end)