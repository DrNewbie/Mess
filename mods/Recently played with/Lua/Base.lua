_G.RPwith = _G.RPwith or {}

RPwith.ModPath = RPwith.ModPath or ModPath

function RPwith:format_time(timestamp, format, tzoffset, tzname)
	if tzoffset == "local" then  -- calculate local time zone (for the server)
		local now = os.time()
		local local_t = os.date("*t", now)
		local utc_t = os.date("!*t", now)
		local delta = (local_t.hour - utc_t.hour)*60 + (local_t.min - utc_t.min)
		local h, m = math.modf( delta / 60)
		tzoffset = string.format("%+.4d", 100 * h + 60 * m)
	end
	tzoffset = tzoffset or "GMT"
	format = format:gsub("%%z", tzname or tzoffset)
	if tzoffset == "GMT" then
		tzoffset = "+0000"
	end
	tzoffset = tzoffset:gsub(":", "")

	local sign = 1
	if tzoffset:sub(1,1) == "-" then
		sign = -1
		tzoffset = tzoffset:sub(2)
	elseif tzoffset:sub(1,1) == "+" then
		tzoffset = tzoffset:sub(2)
	end
	tzoffset = sign * (tonumber(tzoffset:sub(1,2))*60 + tonumber(tzoffset:sub(3,4)))*60
	return os.date(format, timestamp + tzoffset)
end

function RPwith:Record_History(peer_id)
	if not managers.network or not managers.network:session() then
		log("[RPwith]: Record_History \t not managers.network")
		return
	end
	local peer_now = managers.network:session():peer(peer_id)
	if not peer_now then
		log("[RPwith]: Record_History \t no peer_now")
		return
	end
	if peer_now == managers.network:session():local_peer() then
		log("[RPwith]: Record_History \t peer_now == local_peer")
		return
	end
	local _steam_id64 = tostring(peer_now:user_id())
	local _name = tostring(peer_now:name())
	local _level_id = managers.job:has_active_job() and managers.job:current_level_id() or ""
	if _level_id and _level_id ~= "" then
		local _level_name_id = tweak_data.levels[_level_id] and tweak_data.levels[_level_id].name_id
		local _level_name = _level_name_id and managers.localization:text(_level_name_id) or "LEVEL NAME ERROR"
		local _now_time = RPwith:format_time(os.time(), "!%H:%M:%S %z", "local")
		local _record = "\n{".. tostring(json.encode({Player = _name})) ..",\t".. tostring(json.encode({SteamID64 = _steam_id64})) ..",\t".. tostring(json.encode({Is_Host = peer_now:is_host()})) ..",\t".. tostring(json.encode({Time = _now_time})) ..",\t".. tostring(json.encode({Heist = _level_name})) .."}\n"
		local _file = io.open(RPwith.ModPath .. "/history.txt", "a")
		if _file then
			_file:write("" .. _record, "\n")							
			_file:close()
			log("[RPwith]: Record_History \t ".._record)
		end
	end
end

function RPwith:Record_All()
	local _dt = 0
	for peer_id, _ in pairs(managers.network:session():peers()) do
		_dt = _dt + 1
		DelayedCalls:Add('DelayedModRPwithZ_' .. tostring(peer_id), 1 + _dt, function()
			RPwith:Record_History(peer_id)
		end)
	end
end