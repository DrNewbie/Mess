local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local ls_status = Global.ls_status or {}
Global.ls_status = ls_status

local ls_original_hostnetworksession_onjoinrequestreceived = HostNetworkSession.on_join_request_received
function HostNetworkSession:on_join_request_received(...)
	local host_steam_id = self._state_data.local_peer:user_id() or ''
	local sender = select(select('#', ...), ...)
	if not sender then
		return
	end

	local peer_rank = select(6, ...)
	if peer_rank < (Global.game_settings.infamy_permission or 0) then
		self._state:_send_request_denied(sender, 6, host_steam_id)
		return
	end

	if self:amount_of_players() >= Global.game_settings.max_players then
		self._state:_send_request_denied(sender, 5, host_steam_id)
		return
	end

	local steam_id = sender:ip_at_index(0)
	local status = ls_status[steam_id]
	if status == true then
		ls_original_hostnetworksession_onjoinrequestreceived(self, ...)
		return

	elseif type(status) == 'number' then
		self._state:_send_request_denied(sender, status, host_steam_id)
		return
	end

	local is_friend = LobbySettings.friends[steam_id]
	local settings = LobbySettings.settings
	if settings.reject_play_time_threshold > 0 then
		-- Continue
	elseif settings.reject_vac and not is_friend then
		-- Continue
	else
		ls_original_hostnetworksession_onjoinrequestreceived(self, ...)
		return
	end

	local t = TimerManager:wall_running():time()
	if status and t - tonumber(status) < 30 then
		return
	end
	ls_status[steam_id] = tostring(t)

	local params = {...}
	dohttpreq('http://steamcommunity.com/profiles/' .. steam_id .. '/?xml=1',

		function (page)
			if type(page) ~= 'string' then
				ls_status[steam_id] = nil
				return
			end

			if settings.reject_vac and not is_friend then
				local vac_nr = page:match('<vacBanned>(%d+)</vacBanned>')
				local is_ok = not vac_nr or vac_nr == '0'

				if not is_ok then
					ls_status[steam_id] = 9
					self._state:_send_request_denied(sender, 9, host_steam_id)
					return
				end
			end

			if settings.reject_play_time_threshold > 0 then
				local is_ok, retcode
				local hours_nr = page:match('<mostPlayedGame>.-<gameLink>.-218620.-</gameLink>.-<hoursOnRecord>([%d,.]+)</hoursOnRecord>')
				hours_nr = type(hours_nr) == 'string' and hours_nr:gsub(',' , '')
				if hours_nr then
					retcode = 6
					is_ok = tonumber(hours_nr) >= settings.reject_play_time_threshold
				elseif is_friend then
					is_ok = true
				else
					retcode = 3
					is_ok = not settings.reject_unknown_play_time
				end

				if not is_ok then
					ls_status[steam_id] = retcode
					self._state:_send_request_denied(sender, retcode, host_steam_id)
					return
				end
			end

			ls_status[steam_id] = true
			ls_original_hostnetworksession_onjoinrequestreceived(self, unpack(params))
		end

	)
end
