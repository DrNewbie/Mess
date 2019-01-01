_G.SteamUserDates = _G.SteamUserDates or {}

SteamUserDates.Check = SteamUserDates.Check or {}

SteamUserDates.Delay = 90

SteamUserDates.Loop = SteamUserDates.Delay

function SteamUserDates:AnsUserXMLDates(id, data)
	--log(id.."\t"..json.encode(data))
end

function SteamUserDates:GetUserXMLDates(body)
	if body then		
		local dsteamID = tostring(string.match(body, '<steamID><!%[CDATA%[(.*)%]%]></steamID>'))
		local dsteamID64 = tostring(string.match(body, '<steamID64>(%d+)</steamID64>'))
		local dprivacyState = tostring(string.match(body, '<privacyState>(%a+)</privacyState>'))
		local dvisibilityState = tonumber(tostring(string.match(body, '<visibilityState>(%d+)</visibilityState>')))
		local dvacBanned = tonumber(tostring(string.match(body, '<vacBanned>(%d+)</vacBanned>')))
		local dtradeBanState = tostring(string.match(body, '<tradeBanState>(%a+)</tradeBanState>'))
		local disLimitedAccount = tonumber(tostring(string.match(body, '<isLimitedAccount>(%d+)</isLimitedAccount>')))

		self.Check = self.Check or {}
		self.Check[dsteamID64] = self.Check[dsteamID64] or {}
		self.Check[dsteamID64].steamID = dsteamID
		self.Check[dsteamID64].privacyState = dprivacyState
		self.Check[dsteamID64].visibilityState = dvisibilityState
		self.Check[dsteamID64].vacBanned = dvacBanned
		self.Check[dsteamID64].tradeBanState = dtradeBanState
		self.Check[dsteamID64].isLimitedAccount = disLimitedAccount
		self.Check[dsteamID64].GetUserXMLDates = tostring(os.date())
		
		self:AnsUserXMLDates(dsteamID64, self.Check[dsteamID64])
	end
end

function SteamUserDates:MainFunction(peer)
	if not peer or not peer.id or not peer:id() then
		return
	end	
	local steamId64 = tostring(peer:user_id())
	local id = peer:id()
	local is_friend = false
	if Steam and Steam:logged_on() then
		for _, friend in pairs(Steam:friends() or {}) do
			if friend:id() == steamId64 then
				is_friend = true
				break
			end
		end
	end
	self.Check = self.Check or {}
	self.Check[steamId64] = {}
	self.Check[steamId64].is_friend = is_friend
	if managers.network:session():local_peer() == peer then
		self.Check[steamId64].is_yourself = true
	end
	dohttpreq("http://steamcommunity.com/profiles/"..steamId64.."/?xml=1", callback(self, self, "GetUserXMLDates"))
end

if HostNetworkSession then
	Hooks:PostHook(HostNetworkSession, 'on_peer_entered_lobby', "HostGetSteamDatesEnteredLobby", function(self, peer)
		local peer_id = peer:id()
		DelayedCalls:Add('HostDelayedGetSteamDates_' .. tostring(peer_id), 3 + 0.5*peer_id, function()
			SteamUserDates:MainFunction(peer)
		end)
	end)

	Hooks:PostHook(HostNetworkSession, 'on_peer_sync_complete', "HostGetSteamDatesSyncComplete", function(self, peer, peer_id)
		DelayedCalls:Add('HostDelayedGetSteamDates_' .. tostring(peer_id), 3 + 0.5*peer_id, function()
			SteamUserDates:MainFunction(peer)
		end)
	end)
end

if ClientNetworkSession then
	Hooks:PostHook(ClientNetworkSession, 'on_entered_lobby', 'ClientGetSteamDatesEnteredLobby', function(self)
		for peer_id, peer in pairs(managers.network:session():all_peers()) do
			DelayedCalls:Add('ClientDelayedGetSteamDates_'..peer_id, 5 + 1.5*peer_id, function()
				SteamUserDates:MainFunction(peer)
			end)
		end
	end)

	Hooks:PostHook(ClientNetworkSession, 'on_load_complete', 'ClientGetSteamDatesLoadComplete', function(self)
		for peer_id, peer in pairs(managers.network:session():all_peers()) do
			DelayedCalls:Add('ClientDelayedGetSteamDates_'..peer_id, 5 + 1.5*peer_id, function()
				SteamUserDates:MainFunction(peer)
			end)
		end
	end)
end

Hooks:Add("NetworkManagerOnPeerAdded", "AllGetSteamDatesPeerAdded", function(peer, peer_id)
	DelayedCalls:Add('AllDelayedGetSteamDates_' .. tostring(peer_id), 3 + 0.5*peer_id, function()
		SteamUserDates:MainFunction(peer)
	end)
end)

Hooks:Add("GameSetupUpdate", "GetSteamDatesLoopUpdate", function(t, dt)
	if DelayedCalls and SteamUserDates and managers.network and managers.network:session() then
		if SteamUserDates.Loop then
			SteamUserDates.Loop = SteamUserDates.Loop - dt
			if SteamUserDates.Loop <= 0 then
				SteamUserDates.Loop = nil
			end
		else
			SteamUserDates.Loop = SteamUserDates.Delay
			for peer_id, peer in pairs(managers.network:session():all_peers()) do
				DelayedCalls:Add('Loop'..Idstring("DelayedGetSteamDates_"..t.."\t"..dt.."\t"..peer_id):key(), 2 + 1.5*peer_id, function()
					SteamUserDates:MainFunction(peer)
				end)
			end
		end
	end
end)