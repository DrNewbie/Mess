_G.JokeVACBan = _G.JokeVACBan or {}

local JokeVACBanDaysMax = -1

if JokeVACBan and JokeVACBan.Data and type(JokeVACBan.Data.days_max) == "number" then
	if JokeVACBan.Data.days_max == 2 then
		JokeVACBanDaysMax = 30
	elseif JokeVACBan.Data.days_max == 3 then
		JokeVACBanDaysMax = 60
	elseif JokeVACBan.Data.days_max == 4 then
		JokeVACBanDaysMax = 120
	elseif JokeVACBan.Data.days_max == 5 then
		JokeVACBanDaysMax = 240
	elseif JokeVACBan.Data.days_max == 6 then
		JokeVACBanDaysMax = 480
	elseif JokeVACBan.Data.days_max == 7 then
		JokeVACBanDaysMax = 960
	else
		JokeVACBanDaysMax = -1
	end
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
			if not page:find('vacBanned') then
				return
			end
			local vacBanned = tostring(string.match(page, '<vacBanned>(%d+)</vacBanned>'))
			vacBanned = tonumber(vacBanned) or 0
			if vacBanned > 0 then			
				dohttpreq("http://steamcommunity.com/profiles/"..user_id.."/?l=english",
					function (in_page)
						in_page = tostring(in_page)
						if not in_page:find('VAC ban on record') then
							return
						end
						local vacBannedDays = tostring(string.match(in_page, '(%d+) day%(s%) since last ban'))
						vacBannedDays = tonumber(vacBannedDays) or 0
						if vacBannedDays > 0 and (JokeVACBanDaysMax <= 0 or (JokeVACBanDaysMax > 0 and vacBannedDays < JokeVACBanDaysMax)) then
							session:on_peer_kicked(peer, id, 0)
							session:send_to_peers("kick_peer", id, 0)
						end
				end)
			end
	end)
end)