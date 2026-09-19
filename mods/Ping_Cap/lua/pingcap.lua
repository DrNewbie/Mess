if RequiredScript == "lib/managers/menumanager" then
	_G.PingCap = _G.PingCap or {}
	PingCap.ModPath = ModPath
	PingCap.SaveFile = PingCap.SaveFile or SavePath .. "PingCap.txt"
	PingCap.ModOptions = PingCap.ModPath .. "menus/modoptions.txt"
	PingCap.settings = PingCap.settings or {}
	PingCap.options_menu = "PingCap_menu"
	PingCap.settings = {
		maxping_multiplier = 200,
		maxping_times = 7,
		delay = 1,
		loop = 10
	}

	Hooks:Add("LocalizationManagerPostInit", "PingCap_loc", function(loc)
		LocalizationManager:add_localized_strings({
			["ping_cap_menu_title"] = "Ping Cap",
			["ping_cap_menu_desc"] = "",
			["opt_more_ping_cap_title"] = "Ping Cap",
			["opt_more_ping_cap_desc"] = "Set maximum ping that player can have.",
			["opt_more_ping_cap_times_title"] = "Times",
			["opt_more_ping_cap_times_desc"] = "How much times does it need to kick player when 1 loop is done",
			["opt_more_ping_cap_delay_title"] = "Delay",
			["opt_more_ping_cap_delay_desc"] = "How long for next check",
			["opt_more_ping_cap_loop_title"] = "Loop",
			["opt_more_ping_cap_loop_desc"] = "How much times does it need to be 1 loop",
		})
	end)

	function PingCap:Reset()
		self.settings = {
			maxping_multiplier = 200,
			maxping_times = 7,
			delay = 1,
			loop = 10
		}
		self:Save()
	end

	function PingCap:Load()
		local file = io.open(self.SaveFile, "r")
		if file then
			for key, value in pairs(json.decode(file:read("*all"))) do
				self.settings[key] = value
			end
			file:close()
		else
			self:Reset()
		end
	end

	function PingCap:Save()
		local file = io.open(self.SaveFile, "w+")
		if file then
			file:write(json.encode(self.settings))
			file:close()
		end
	end

	PingCap:Load()

	if not PingCap.settings.maxping_multiplier then 
		PingCap.settings.maxping_multiplier = "200"
		PingCap:Save()
	end

	PingCap:Load()

	Hooks:Add("MenuManagerSetupCustomMenus", "PingCapOptions", function( menu_manager, nodes )
		MenuHelper:NewMenu( PingCap.options_menu )
	end)

	Hooks:Add("MenuManagerPopulateCustomMenus", "PingCapOptions", function( menu_manager, nodes )
		MenuCallbackHandler.set_maxping_multiplier = function(self, item)
			PingCap.settings.maxping_multiplier = math.floor(item:value())
			PingCap:Save()
		end
		MenuHelper:AddSlider({
			id = "set_maxping_multiplier",
			title = "opt_more_ping_cap_title",
			desc = "opt_more_ping_cap_desc",
			callback = "set_maxping_multiplier",
			min = 10,
			max = 900,
			step = 10,
			value = PingCap.settings.maxping_multiplier,
			menu_id = PingCap.options_menu,
			show_value = true,
		})
		MenuCallbackHandler.set_maxping_times = function(self, item)
			PingCap.settings.maxping_times = math.floor(item:value())
			PingCap:Save()
		end
		MenuHelper:AddSlider({
			id = "set_maxping_times",
			title = "opt_more_ping_cap_times_title",
			desc = "opt_more_ping_cap_times_desc",
			callback = "set_maxping_times",
			min = 1,
			max = 60,
			step = 1,
			value = PingCap.settings.maxping_times,
			menu_id = PingCap.options_menu,
			show_value = true,
		})
		MenuCallbackHandler.set_delay = function(self, item)
			PingCap.settings.delay = math.floor(item:value())
			PingCap:Save()
		end
		MenuHelper:AddSlider({
			id = "set_delay",
			title = "opt_more_ping_cap_delay_title",
			desc = "opt_more_ping_cap_delay_desc",
			callback = "set_delay",
			min = 1,
			max = 60,
			step = 1,
			value = PingCap.settings.delay,
			menu_id = PingCap.options_menu,
			show_value = true,
		})
		MenuCallbackHandler.set_loop = function(self, item)
			PingCap.settings.loop = math.floor(item:value())
			PingCap:Save()
		end
		MenuHelper:AddSlider({
			id = "set_loop",
			title = "opt_more_ping_cap_loop_title",
			desc = "opt_more_ping_cap_loop_desc",
			callback = "set_loop",
			min = 1,
			max = 60,
			step = 1,
			value = PingCap.settings.loop,
			menu_id = PingCap.options_menu,
			show_value = true,
		})
	end)

	Hooks:Add("MenuManagerBuildCustomMenus", "PingCapOptions", function(menu_manager, nodes)
		nodes[PingCap.options_menu] = MenuHelper:BuildMenu( PingCap.options_menu )
		MenuHelper:AddMenuItem(nodes["blt_options"], PingCap.options_menu, "ping_cap_menu_title", "ping_cap_menu_desc")
	end)
end

if RequiredScript == "lib/managers/hud/hudheisttimer" then
	if Network:is_client() then
		return
	end
	PingCap._RUN_Dalay = 0
	PingCap._Record_List = {id_1 = {}, id_2 = {}, id_3 = {}, id_4 = {}}
	local _PingCap_Special_HUDHeistTimer_set_time = HUDHeistTimer.set_time
	function HUDHeistTimer:set_time(...)
		_PingCap_Special_HUDHeistTimer_set_time(self, ...)
		if not Utils:IsInHeist() or not PingCap or PingCap._RUN_Dalay > self._last_time then
			return
		end
		PingCap._RUN_Dalay = self._last_time + PingCap.settings.delay
		if not managers.network or not managers.network:session() then
			return
		end
		local _peers = managers.network:session():peers() or {}
		for _, _peer in pairs(_peers) do
			if _peer and _peer ~= managers.network:session():local_peer() then
				local _id = _peer:id()
				local _idx = "id_" .. math.clamp(_id, 1, 4)
				local _qos = _peer:qos() or nil
				if _qos then
					local _ping = _qos and _qos.ping or 0
					_ping = math.round(_ping)
					table.insert(PingCap._Record_List[_idx], _ping)
					local _size = table.size(PingCap._Record_List[_idx])
					local _times = 0
					local _avg_ping_h = 0
					for _, _ping_h in pairs(PingCap._Record_List[_idx]) do
						if _ping_h > PingCap.settings.maxping_multiplier then
							_times = _times + 1
							_avg_ping_h = _avg_ping_h + _ping_h
							if _times >= PingCap.settings.maxping_times then
								break
							end
						end
					end
					_avg_ping_h = math.round(_avg_ping_h/PingCap.settings.maxping_times)
					local reason = "'" .. _peer:name() .. "' PING '" .. _avg_ping_h .. "' is over '" .. PingCap.settings.maxping_multiplier .. "'"
					if _size >= PingCap.settings.loop then
						if _times >= PingCap.settings.maxping_times then
							managers.chat:feed_system_message(ChatManager.GAME, reason, "")
							managers.network:session():send_to_peers("kick_peer", _id, 2)
							managers.network:session():on_peer_kicked(_peer, _id, 2)
						end
						PingCap._Record_List[_idx] = {}
					else				
						if _avg_ping_h > PingCap.settings.maxping_multiplier and _times >= (PingCap.settings.maxping_times/2)+1 and _size >= (PingCap.settings.loop/2)+1 then
							managers.chat:send_message(ChatManager.GAME, "", tostring("[!] '" .. reason))
						end
					end
				end
			end
		end
	end
end