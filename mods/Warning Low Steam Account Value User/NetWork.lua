_G.JokeSteamPriceBan = _G.JokeSteamPriceBan or {}
JokeSteamPriceBan.Data = JokeSteamPriceBan.Data or {low_value = 0, msg_type = 1}
JokeSteamPriceBan.Check = JokeSteamPriceBan.Check or {}

function JokeSteamPriceBan:MainFunction(peer)
	local session = managers.network:session()
	if not peer or not peer.id or not peer:id() or self.Data.low_value <= 0 or peer == session:local_peer() then
		return
	end
	local user_id = peer:user_id()
	if self.Check[Idstring(user_id):key()] then
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
	dohttpreq('https://steamdb.info/calculator/'..user_id..'/?cc=us',
		function (page)
			if self.Check[Idstring(user_id):key()] then
				return
			end
			self.Check[Idstring(user_id):key()] = true			
			page = tostring(page)
			if page:find('<div>Account Value</div>') and page:find('<span class="number%-price">') then
				local _, __price, _ = page:match('<span class="number%-price"><span hidden>(%d+)</span>$(%d+)<span hidden>(%d+)</span></span>')
				__price = tonumber(tostring(__price)) or -1
				if __price < self.Data.low_value then
					if self.Data.msg_type == 2 or self.Data.msg_type == 3 then
						managers.chat:send_message(ChatManager.GAME, "", "[LowAccountValue]: "..peer:name().." steam account value '$"..__price.."' is lower than $"..JokeSteamPriceBan.Data.low_value)
					end
					if self.Data.msg_type == 1 or self.Data.msg_type == 3 then
						managers.chat:_receive_message(ChatManager.GAME, "[LowAccountValue]", peer:name().." steam account value '$"..__price.."' is lower than $"..JokeSteamPriceBan.Data.low_value, Color.red)
					end
				else
					if self.Data.msg_type == 2 or self.Data.msg_type == 3 then
						managers.chat:send_message(ChatManager.GAME, "", "[LowAccountValue]: "..peer:name().." steam account value is '$"..__price.."'")
					end
					if self.Data.msg_type == 1 or self.Data.msg_type == 3 then
						managers.chat:_receive_message(ChatManager.GAME, "[LowAccountValue]", peer:name().." steam account value is '$"..__price.."'", Color.green)
					end
				end
			else
				managers.chat:_receive_message(ChatManager.GAME, "[LowAccountValue]", peer:name().." steam account value is fail to read.", Color.yellow)
			end
	end)
end

function JokeSteamPriceBan:Check_All()
	if not managers.network or not managers.network:session() or not managers.network:session():peers() then
		return
	end
	local _dt = 0
	for peer_id, peer in pairs(managers.network:session():peers()) do
		_dt = _dt + 3
		DelayedCalls:Add('DelayedModJokeSteamPriceBan_' .. tostring(peer_id), 1 + _dt, function()
			JokeSteamPriceBan:MainFunction(peer)
		end)
	end
end

if HostNetworkSession then
	Hooks:PostHook(HostNetworkSession, 'on_peer_entered_lobby', 'F_'..Idstring('SteamPrice:HostNetworkSessionOnPeerEnteredLobby'):key(), function(self, peer)
		local peer_id = peer:id()
		DelayedCalls:Add('DelayedModSteamPriceX_' .. tostring(peer_id), 1, function()
			JokeSteamPriceBan:Check_All()
		end)
	end)
end

if ClientNetworkSession then
	Hooks:PostHook(ClientNetworkSession, 'on_entered_lobby', 'F_'..Idstring('SteamPrice:ClientNetworkSessionOnEnteredLobby'):key(), function(self)
		DelayedCalls:Add('DelayedModSteamPriceW_', 3, function()
			JokeSteamPriceBan:Check_All()
		end)
	end)
	Hooks:PostHook(ClientNetworkSession, 'on_load_complete', 'F_'..Idstring('SteamPrice:ClientNetworkSessionOnLoadComplete'):key(), function(self)
		DelayedCalls:Add('DelayedModSteamPriceZ_', 3, function()
			JokeSteamPriceBan:Check_All()
		end)
	end)
end

if NetworkPeer then
	Hooks:PostHook(NetworkPeer, "set_ip_verified", 'F_'..Idstring('SteamPrice:PostHook:NetworkPeer:set_ip_verified'):key(), function(self)
		if self and self.id then
			local peer_id = self:id()
			DelayedCalls:Add('DelayedModSteamPriceY_' .. tostring(peer_id), 1, function()
				JokeSteamPriceBan:Check_All()
			end)
		end
	end)
end