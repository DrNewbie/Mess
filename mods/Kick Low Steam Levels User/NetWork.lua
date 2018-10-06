_G.JokeSteamLevelsBan = _G.JokeSteamLevelsBan or {}

JokeSteamLevelsBan.Data = JokeSteamLevelsBan.Data or {low_leves = 0}

Hooks:Add("NetworkManagerOnPeerAdded", "JokeSteamLevelsKicked", function(peer, peer_id)
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
	dohttpreq("http://steamcommunity.com/profiles/"..user_id.."/?l=english",
		function (page)
			page = tostring(page)
			local levels = 0
			if not page:find('friendPlayerLevelNum') then
				
			else
				levels = tostring(string.match(page, '<span class="friendPlayerLevelNum">(%d+)</span>'))
				levels = tonumber(levels) or 0
			end			
			if levels < JokeSteamLevelsBan.Data.low_leves then			
				session:on_peer_kicked(peer, id, 0)
				session:send_to_peers("kick_peer", id, 0)
				managers.chat:_receive_message(ChatManager.GAME, "[LowSteamLevels]", peer:name().." steam levels '"..levels.."' is lower than "..JokeSteamLevelsBan.Data.low_leves, Color.red)
			end
	end)
end)