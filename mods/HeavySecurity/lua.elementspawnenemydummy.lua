HeavySecurity = HeavySecurity or nil

core:import("CoreMissionScriptElement")
ElementSpawnEnemyDummy = ElementSpawnEnemyDummy or class(CoreMissionScriptElement.MissionScriptElement)

Hooks:PostHook(ElementSpawnEnemyDummy, "produce", "F_"..Idstring("Post.ElementSpawnEnemyDummy.produce.HeavySecurity"):key(), function(self, params)
	if not HeavySecurity or not HeavySecurity.settings or not HeavySecurity.settings.Level or not HeavySecurity.settings.Enable then
	
	else
		if not Network:is_client() and managers.groupai:state():whisper_mode() and self._units and self._units[#self._units] then
			_cop = self._units[#self._units]
			local _editor_name = tostring(self._editor_name)
			local _id = tostring(self._id)
			local _id_list = {
				["branchbank"] = "100294, 100297, 101063, 100296, 101219, 105100",
				["firestarter_3"] = "100294, 100297, 101063, 100296, 101219, 105100",
				["jewelry_store"] = "102737, 102736, 102739, 102738, 102120, 102151",
				["ukrainian_job"] = "102739, 102151, 102120, 100792, 102044, 102046, 102738, 102736, 103491, 103490, 103486, 102179",
				["four_stores"] = "102344, 102326",
				["gallery"] = "100211, 100446, 100459, 100444, 100448, 100460, 100445, 102096",
				["framing_frame_1"] = "100448, 100446, 100459, 100460, 100444, 100445, 102096, 100211",
				["nightclub"] = "103452, 100513, 102193, 102709, 100523, 102619, 100534, 102200, 103450, 102617, 101252, 100530, 101934, 102708, 102202",
				["election_day_1"] = "102983, 100168, 100172, 100488, 100478, 100490, 100487, 102982, 103734",
				["hox_3"] = "101364, 100709, 101495, 101305, 101304, 101302, 101303, 101383, 101494, 101541, 100711, 101368",		
				["big"] = "100710, 100709",
				["family"] = "100709"
			}
			local _level_id = ""
			if Global.game_settings and Global.game_settings.level_id then
				_level_id = Global.game_settings.level_id
			end
			--if _editor_name then
			--	log("HeavySecurity: " .. tostring( json.encode( {_editor_name = _editor_name, _level_id = _level_id, _id = _id} ) ) )
			--end
			if (_editor_name:find("patrol") and _editor_name:find("guard")) or 
				(_id_list[_level_id] and _id_list[_level_id]:find(_id)) or 
				(_level_id == "dark" and _editor_name:find("patrol")) or 
				(_level_id == "crojob2" and _editor_name:find("guard")) or 
				(_level_id == "kenaz" and _editor_name:find("ai_spawn_enemy")) or 
				(_level_id == "welcome_to_the_jungle_2" and _editor_name:find("ai_spawn_enemy")) or
				(_level_id == "fish" and _editor_name:find("ai_spawn_security")) or 
				(_level_id == "dah" and _editor_name:find("patrol")) or 
				(HeavySecurity.settings.AllEnemies and managers.enemy:is_enemy(_cop)) then
				for i = 1, HeavySecurity.settings.Level do
					HeavySecurity:Spawn(_cop, self)
				end				
			end
			if not HeavySecurity.SpawnAtOnce then
				HeavySecurity.SpawnAtOnce = true
				DelayedCalls:Add("D_"..Idstring("DelayedModAnnounce_HeavySecurity_SecurityLevel"):key(), 5,  function()
					if managers.chat then
						managers.chat:_receive_message(1, "Heavy Security MOD", "Current Security Level is " .. HeavySecurity.settings.Level, Color.green)
					end
				end)
				if HeavySecurity.settings.AddonFollower > 0 then
					if type(HeavySecurity.settings.AddonFollowerReady) ~= "table" then
						HeavySecurity.settings.AddonFollowerReady = {}
					end
					for i = 1, HeavySecurity.settings.AddonFollower do
						table.insert(HeavySecurity.settings.AddonFollowerReady, {
							cop = _cop,
							them = self
						})
					end
				end
			end
		end
	end
end)

Hooks:Add("GameSetupUpdate", "GameSetupUpdate_HeavySecurity", function()
	if HeavySecurity and HeavySecurity.settings and HeavySecurity.settings.AddonFollowerReady and Utils:IsInHeist() then
		local sp_list = HeavySecurity.settings.AddonFollowerReady
		HeavySecurity.settings.AddonFollowerReady = nil
		local playerss = managers.groupai:state():all_player_criminals()
		if not playerss then
			playerss = {
				key = {
					unit = managers.player:player_unit()
				}
			}
		end
		if playerss then
			for i, d in pairs(sp_list) do
				DelayedCalls:Add("D_"..Idstring("DelayedModAnnounce_HeavySecurity_AddonFollower_"):key(), 3,  function()
					if managers.chat then
						managers.chat:_receive_message(1, "Heavy Security MOD", "Addon follower level " .. HeavySecurity.settings.AddonFollower, Color.green)
					end
				end)
				DelayedCalls:Add("D_"..Idstring("DelayedMod_HeavySecurity_AddonFollower_"..i):key(), 3 + i*0.25,  function()
					local cc = playerss[table.random_key(playerss)]
					if Utils:IsInHeist() and d and cc and cc.unit and alive(cc.unit) and d.cop and alive(d.cop) and d.them then
						HeavySecurity:Spawn(d.cop, d.them, cc.unit)
					end
				end)
			end
		end
	end
end)