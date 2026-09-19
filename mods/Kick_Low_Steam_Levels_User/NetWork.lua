_G.JokeSteamLevelsBan = _G.JokeSteamLevelsBan or {}

JokeSteamLevelsBan.Data = JokeSteamLevelsBan.Data or {low_leves = 0, kick_type = 1, msg_type = 1}

JokeSteamLevelsBan.Wait = JokeSteamLevelsBan.Wait or {}

JokeSteamLevelsBan.Check = JokeSteamLevelsBan.Check or {}

function JokeSteamLevelsBan:MainFunction(peer)
	local session = managers.network:session()
	if not peer or not peer.id or not peer:id() then
		return
	end
	local user_id = peer:user_id()
	if JokeSteamLevelsBan.Check[Idstring(user_id):key()] then
		return
	end
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
			JokeSteamLevelsBan.Check[Idstring(user_id):key()] = true
			
			page = tostring(page)
			local levels = 0
			if not page:find('friendPlayerLevelNum') then
				
			else
				levels = tostring(string.match(page, '<span class="friendPlayerLevelNum">(%d+)</span>'))
				levels = tonumber(levels) or 0
			end			
			if levels < self.Data.low_leves then
				if self.Data.kick_type == 1 then
					session:on_peer_kicked(peer, id, 0)
					session:send_to_peers("kick_peer", id, 0)
				else
					self.Wait[Idstring(user_id):key()] = {peer = peer, user_id = user_id, t = 15}
				end
				if self.Data.msg_type == 2 or self.Data.msg_type == 3 then
					managers.chat:send_message(ChatManager.GAME, "", "[LowSteamLevels]: "..peer:name().." steam levels '"..levels.."' is lower than "..JokeSteamLevelsBan.Data.low_leves)
				end
				if self.Data.msg_type == 1 or self.Data.msg_type == 3 then
					managers.chat:_receive_message(ChatManager.GAME, "[LowSteamLevels]", peer:name().." steam levels '"..levels.."' is lower than "..JokeSteamLevelsBan.Data.low_leves, Color.red)
				end
			else
				if self.Data.msg_type == 1 or self.Data.msg_type == 3 then
					managers.chat:_receive_message(ChatManager.GAME, "[LowSteamLevels]", peer:name().." steam levels is '"..levels.."'", Color.green)
				end
			end
	end)
end

Hooks:PostHook(HostNetworkSession, 'on_peer_entered_lobby', "JokeSteamLevelsKicked_OnPeerEnteredLobby", function(self, peer)
	local peer_id = peer:id()
	DelayedCalls:Add('DelayedJokeSteamLevelsKicked' .. tostring(peer_id), 5, function()
		JokeSteamLevelsBan:MainFunction(peer)
	end)
end)

Hooks:PostHook(HostNetworkSession, 'on_peer_sync_complete', "JokeSteamLevelsKicked_OnPeerSyncComplete", function(self, peer, peer_id)
	DelayedCalls:Add('DelayedJokeSteamLevelsKicked' .. tostring(peer_id), 5, function()
		JokeSteamLevelsBan:MainFunction(peer)
	end)
end)

Hooks:Add("NetworkManagerOnPeerAdded", "JokeSteamLevelsKicked_OnPeerAdded", function(peer, peer_id)
	DelayedCalls:Add('DelayedJokeSteamLevelsKicked' .. tostring(peer_id), 5, function()
		JokeSteamLevelsBan:MainFunction(peer)
	end)
end)

Hooks:Add("GameSetupUpdate", "JokeSteamLevelsDelayKick", function(t, dt)
	if managers.network and managers.network:session() and type(JokeSteamLevelsBan.Wait) == "table" then
		for id, data in pairs(JokeSteamLevelsBan.Wait) do
			if type(data.t) ~= "number" then
				JokeSteamLevelsBan.Wait[id] = nil
			else
				if data.t then
					data.t = data.t - dt
					if data.t <= 0 then
						data.t = nil
						if data.peer and data.peer.id and data.peer.user_id and data.user_id == data.peer:user_id() then
							managers.network:session():on_peer_kicked(data.peer, data.peer:id(), 0)
							managers.network:session():send_to_peers("kick_peer", data.peer:id(), 0)
						end
					end
				end
			end
		end
	end
end)