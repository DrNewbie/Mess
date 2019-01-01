local function UpdatePlayerName(data)
	if managers.network and type(data) == "table" and data.them and data.peer and data.peer.id and managers.network:session():peer(data.peer:id()) and data.try < 10 then
		dohttpreq("http://steamcommunity.com/profiles/"..tostring(data.peer:user_id()).."/?xml=1", 
			function (page)
				local peer_id = data.peer:id()
				if page then
					page = tostring(page)
					local player_steam_name = tostring(string.match(page, '<steamID><!%[CDATA%[(.*)%]%]></steamID>'))
					if data.s == 1 then
						data.them:set_teammate_name(data.them_i, player_steam_name)
						local name_label = data.them:_name_label_by_peer_id(peer_id)
						if name_label then
							name_label.panel:child("text"):set_text(player_steam_name)
						end
					elseif data.s == 2 then
						data.peer:set_name(player_steam_name)
					end
				else
					data.try = data.try + 1
					DelayedCalls:Add('DelayedCallsUpdatePlayerName'..data.peer:id(), 3 + 1.5*peer_id, function()
						UpdatePlayerName(data)
					end)
				end
			end
		)
	end
end

if HUDManager then
	Hooks:PostHook(HUDManager, "set_teammate_name", "UnUnknowNameAttach1", function(self, i, teammate_name)
		if string.upper(tostring(teammate_name)) == "[UNKNOWN]" then
			if managers.network and managers.network:session() then
				if self._teammate_panels[i] then
					local peer_id = self._teammate_panels[i]:peer_id()
					if peer_id then
						local peer = managers.network and managers.network:session():peer(peer_id)
						if peer then
							DelayedCalls:Add('DelayUUKNFix1'..peer_id, 3 + 1.5*peer_id, function()
								UpdatePlayerName({s = 1, peer = peer, try = 1, them = self, them_i = i})
							end)
						end
					end
				end	
			end
		end
	end)
end

if NetworkPeer then
	Hooks:PostHook(NetworkPeer, "name", "UnUnknowNameAttach2", function(self)
		if DelayedCalls and self:id() and self:user_id() and not self._ununknownamefix and string.upper(tostring(self._name)) == "[UNKNOWN]" then
			self._ununknownamefix = true
			DelayedCalls:Add('DelayUUKNFix2'..self:id(), 1.5*self:id(), function()
				UpdatePlayerName({s = 2, peer = self, try = 1, them = self})
			end)
		end
	end)
end