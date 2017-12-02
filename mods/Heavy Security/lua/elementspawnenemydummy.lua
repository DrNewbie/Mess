_G.HeavySecurity = _G.HeavySecurity or {}

if not HeavySecurity or not HeavySecurity.settings or not HeavySecurity.settings.Level then
	return
end

local HeavySecurity_SpawnEnemyDummy = ElementSpawnEnemyDummy.produce

HeavySecurity.SpawnAtOnce = false

function ElementSpawnEnemyDummy:produce(...)
	local _cop = HeavySecurity_SpawnEnemyDummy(self, ...)
	if not Network:is_client() and managers.groupai:state():whisper_mode() then
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
		local _spawn_list = {
			"units/payday2/characters/ene_bulldozer_1/ene_bulldozer_1",
			"units/payday2/characters/ene_bulldozer_2/ene_bulldozer_2",
			"units/payday2/characters/ene_bulldozer_3/ene_bulldozer_3",
			"units/payday2/characters/ene_spook_1/ene_spook_1",
			"units/payday2/characters/ene_shield_2/ene_shield_2",
			"units/payday2/characters/ene_tazer_1/ene_tazer_1"		
		}
		local _spawn_select = _spawn_list[HeavySecurity.settings.Enemy_Type]
		local _level_id = ""
		if Global.game_settings and Global.game_settings.level_id then
			_level_id = Global.game_settings.level_id
		end
		if _editor_name then
			log("HeavySecurity: " .. tostring( json.encode( {_editor_name = _editor_name, _level_id = _level_id, _id = _id} ) ) )
		end
		if (_editor_name:find("patrol") and _editor_name:find("guard")) or 
			(_id_list[_level_id] and _id_list[_level_id]:find(_id)) or 
			(_level_id == "dark" and _editor_name:find("patrol")) or 
			(_level_id == "crojob2" and _editor_name:find("guard")) or 
			(_level_id == "kenaz" and _editor_name:find("ai_spawn_enemy")) or 
			(_level_id == "welcome_to_the_jungle_2" and _editor_name:find("ai_spawn_enemy")) or
			(_level_id == "fish" and _editor_name:find("ai_spawn_security")) or 
			(_level_id == "dah" and _editor_name:find("patrol")) then
			local _u, team_id
			local new_objective = {
				type = "follow",
				follow_unit = _cop,
				scan = true,
				is_default = true
			}
			for i = 1, HeavySecurity.settings.Level do
				_u = safe_spawn_unit(Idstring(_spawn_select), self:get_orientation())
				if _u then
					if not team_id then
						team_id = tweak_data.levels:get_default_team_ID(_u:base():char_tweak().access == "gangster" and "gangster" or "combatant")
					end
					if self._values.participate_to_group_ai then
						managers.groupai:state():assign_enemy_to_group_ai(_u, team_id)
					else
						managers.groupai:state():set_char_team(_u, team_id)
					end
					_u:brain():set_spawn_ai( { init_state = "idle", params = { scan = true }, objective = new_objective } )
					_u:brain():on_reload()
					_u:brain():terminate_all_suspicion()
					_u:movement():set_cool(true)
					_u:brain():on_cool_state_changed(true)
					_u = nil
					managers.groupai:state():_clear_criminal_suspicion_data()
				end
			end
		end
		if not HeavySecurity.SpawnAtOnce then
			HeavySecurity.SpawnAtOnce = true
			DelayedCalls:Add("DelayedModAnnounces_HeavySecurity_SecurityLevel", 5,  function()
				managers.chat:_receive_message(1, "Heavy Security MOD", "Current Security Level is " .. HeavySecurity.settings.Level, Color.green)
			end)
		end
	end
	return _cop
end