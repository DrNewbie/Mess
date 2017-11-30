if ModCore then
	ModCore:new(ModPath.."Updater.xml", false, true):init_modules()
end

Hooks:Add("NetworkManagerOnPeerAdded", "KickVACBanned", function(peer, peer_id)
	local session = managers.network:session()
	local peer = session:peer(peer_id)
	if not peer then
		return
	end
	local user_id = peer:user_id()
	local id = peer:id()
	if Steam and Steam:logged_on() then
		for _, friend in ipairs(Steam:friends() or {}) do
			if friend:id() == user_id then
				return
			end
		end
	end
	dohttpreq("http://steamcommunity.com/profiles/"..user_id.."/?xml=1",
		function (page)
			page = tostring(page)
			local vacBanned = tostring(string.match(page, '<vacBanned>(%d+)</vacBanned>'))
			vacBanned = tonumber(vacBanned) or 0
			if vacBanned > 0 then
				session:on_peer_kicked(peer, id, 0)
				session:send_to_peers("kick_peer", id, 0)
			end
	end)
end)