_G.RPwith = _G.RPwith or {}

RPwith.Ban_list_SteamID64 = RPwith.Ban_list_SteamID64 or {}
RPwith.ModPath = RPwith.ModPath or ModPath

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