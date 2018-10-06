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
				--return
			end
		end
	end
	DelayedCalls:Add('JokeSteamLevelsKicked_Delay_'..user_id, 3, function()
		dohttpreq("http://steamcommunity.com/profiles/"..user_id.."/?l=english",
			function (page)
				page = tostring(page)
				if not page:find('friendPlayerLevelNum') then
					return
				end			
				local levels = tostring(string.match(page, '<span class="friendPlayerLevelNum">(%d+)</span>'))
				levels = tonumber(levels) or 0
				if levels < JokeSteamLevelsBan.Data.low_leves then			
					session:on_peer_kicked(peer, id, 0)
					session:send_to_peers("kick_peer", id, 0)
					managers.chat:_receive_message(ChatManager.GAME, "[LowSteamLevels]", peer:name().." steam levels '"..levels.."' is lower than "..JokeSteamLevelsBan.Data.low_leves, Color.red)
				end
		end)
	end)
end)