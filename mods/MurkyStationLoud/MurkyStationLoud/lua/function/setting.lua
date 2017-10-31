if Network:is_client() then
	return
end

_G.ShadowRaidLoud = _G.ShadowRaidLoud or {}

ShadowRaidLoud.Level_ID = "dark"
ShadowRaidLoud.Message2OtherPlayers = "This lobby is running 'Murky Station Loud Mod'"
ShadowRaidLoud.Message2WarnYou = "You're activating Murky Station Loud MOD. \n You should only play with your friends."

ShadowRaidLoud.Unit_Remove_When_Loud = {
	{	key = "b025e83ed6d542b4",
		position = {
			Vector3(3041, 749.998, -700),
			Vector3(1041, 749.999, -700),
			Vector3(-158, 749.998, -700),
			Vector3(-2558, 750, -700),
			Vector3(-2500, 4400, -700),
			Vector3(-900, 4400, -700),
			Vector3(2200, 4400, -700),
			Vector3(2600, 4400, -700),
			Vector3(2641, 749.998, -700),
			Vector3(300, 4400, -700)
		}
	},
	{	key = "23390d90d6ed7e76",
		position = {
			Vector3(0, 0, 0)
		}
	}
}

ShadowRaidLoud.Time2FirstSpawn = {easy = 60,
	normal = 60,
	hard = 60,
	overkill = 40,
	overkill_145 = 40,
	overkill_290 = 30
}
ShadowRaidLoud.Time2RepeatSpawn = {easy = 3,
	normal = 20,
	hard = 20,
	overkill = 20,
	overkill_145 = 20,
	overkill_290 = 20
}
ShadowRaidLoud.Time2OpenVault = {easy = 360,
	normal = 360,
	hard = 480,
	overkill = 480,
	overkill_145 = 480,
	overkill_290 = 600
}
ShadowRaidLoud._Spawning = {easy = 1,
	normal = 2,
	hard = 2,
	overkill = 2,
	overkill_145 = 2,
	overkill_290 = 2
}
ShadowRaidLoud._Spawning_Total = {easy = 40,
	normal = 50,
	hard = 60,
	overkill = 60,
	overkill_145 = 70,
	overkill_290 = 70
}
ShadowRaidLoud._Spawning_Other_Total = {
	sniper = {
		easy = 5,
		normal = 5,
		hard = 5,
		overkill = 5,
		overkill_145 = 5,
		overkill_290 = 5
	},
	taser = {
		easy = 2,
		normal = 4,
		hard = 4,
		overkill = 4,
		overkill_145 = 6,
		overkill_290 = 6
	},
	shield = {
		easy = 10,
		normal = 20,
		hard = 20,
		overkill = 30,
		overkill_145 = 30,
		overkill_290 = 30
	},
	spooc = {
		easy = 2,
		normal = 2,
		hard = 2,
		overkill = 3,
		overkill_145 = 4,
		overkill_290 = 5
	},
	tank = {
		easy = 2,
		normal = 3,
		hard = 4,
		overkill = 5,
		overkill_145 = 6,
		overkill_290 = 8
	}
}

ShadowRaidLoud.Difficulty = Global.game_settings and Global.game_settings.difficulty or "easy"

local _D = ShadowRaidLoud.Difficulty

ShadowRaidLoud.Time4Use = {
	FirstSpawn = ShadowRaidLoud.Time2FirstSpawn[_D],
	RepeatSpawn = ShadowRaidLoud.Time2RepeatSpawn[_D],
	OpenVault = ShadowRaidLoud.Time2OpenVault[_D],
}

--Spawn_Settings
	local _default_enemy = {
		{ type = "units/payday2/characters/ene_murkywater_1/ene_murkywater_1", amount = 3}				
	}
	ShadowRaidLoud.Spawn_Settings = {}
	local Spawn_Settings = {}
	local Spawn_Settings_List = {}

	Spawn_Settings.palce_1 = {
		group_id = 1,
		position = {Vector3(3202.7, 586.491, -700.008), Vector3(3098.97, 515.575, -700.007), Vector3(3105.69, 664.135, -700.009)},
		rotation = {Rotation(0, 0, 1)},
		enemy = {easy = _default_enemy,
				normal = _default_enemy,
				hard = _default_enemy,
				overkill = _default_enemy,
				overkill_145 = _default_enemy,
				overkill_290 = _default_enemy},
	}
	table.insert(Spawn_Settings_List, "palce_1")

	Spawn_Settings.palce_2 = deep_clone(Spawn_Settings.palce_1)
	Spawn_Settings.palce_2.group_id = 2
	Spawn_Settings.palce_2.position = {Vector3(-4113.92, 442.69, 0), Vector3(-3981.77, 486.164, 0), Vector3(-3805.37, 508.707, 0)}
	table.insert(Spawn_Settings_List, "palce_2")
	
	Spawn_Settings.palce_3 = deep_clone(Spawn_Settings.palce_1)
	Spawn_Settings.palce_3.group_id = 3
	Spawn_Settings.palce_3.position = {Vector3(-311.881, -575.421, 0), Vector3(-442.423, -723.203, 0), Vector3(-589.216, -862.885, 5)}
	table.insert(Spawn_Settings_List, "palce_3")
	
	Spawn_Settings.palce_4 = deep_clone(Spawn_Settings.palce_1)
	Spawn_Settings.palce_4.group_id = 4
	Spawn_Settings.palce_4.position = {Vector3(1991.58, 1224.7, -261.564), Vector3(1109.55, 1219.53, -226.491), Vector3(517.633, 1199.83, -231.08)}
	table.insert(Spawn_Settings_List, "palce_4")
	
	Spawn_Settings.palce_5 = deep_clone(Spawn_Settings.palce_1)
	Spawn_Settings.palce_5.group_id = 5
	Spawn_Settings.palce_5.position = {Vector3(4712.76, 1405.89, -700.002), Vector3(4462.91, 1753.63, -700.005), Vector3(4575.32, 1906.78, -700.004)}
	table.insert(Spawn_Settings_List, "palce_5")
	
	Spawn_Settings.palce_6 = deep_clone(Spawn_Settings.palce_1)
	Spawn_Settings.palce_6.group_id = 6
	Spawn_Settings.palce_6.position = {Vector3(4584.74, 3485.85, -700.005), Vector3(4724.86, 3245.02, -700.003), Vector3(4630.55, 2880.39, -700.004)}
	table.insert(Spawn_Settings_List, "palce_6")
	
	Spawn_Settings.palce_7 = deep_clone(Spawn_Settings.palce_1)
	Spawn_Settings.palce_7.group_id = 7
	Spawn_Settings.palce_7.position = {Vector3(-2379.85, 4527.01, -700), Vector3(-2203.35, 4706.74, -700), Vector3(-2041.36, 4785.12, -700)}
	table.insert(Spawn_Settings_List, "palce_7")
	
	Spawn_Settings.palce_8 = deep_clone(Spawn_Settings.palce_1)
	Spawn_Settings.palce_8.group_id = 8
	Spawn_Settings.palce_8.position = {Vector3(3554.01, 4781.07, -700),  Vector3(3646.41, 4672.44, -700.001), Vector3(3631.84, 4518.62, -700.003)}
	table.insert(Spawn_Settings_List, "palce_8")
	
	Spawn_Settings.palce_9 = deep_clone(Spawn_Settings.palce_1)
	Spawn_Settings.palce_9.group_id = 9
	Spawn_Settings.palce_9.position = {Vector3(965.158, 4853.61, -1100.01), Vector3(952.189, 4922.49, -1100.01), Vector3(1026.23, 5001.7, -1100.01)}
	table.insert(Spawn_Settings_List, "palce_9")

	Spawn_Settings.palce_10 = deep_clone(Spawn_Settings.palce_1)
	Spawn_Settings.palce_10.group_id = 10
	Spawn_Settings.palce_10.position = {Vector3(816.521, 2706.69, -1200), Vector3(886.387, 2548.19, -1200), Vector3(734.469, 2419.99, -1200)}
	table.insert(Spawn_Settings_List, "palce_10")
	
	Spawn_Settings.palce_11 = deep_clone(Spawn_Settings.palce_1)
	Spawn_Settings.palce_11.group_id = 11
	Spawn_Settings.palce_11.position = {Vector3(163.087, 648.535, -1207.99), Vector3(-33.7929, 496.34, -1207.99), Vector3(-278.425, 546.047, -1200)}
	table.insert(Spawn_Settings_List, "palce_11")
	
	Spawn_Settings.palce_12 = deep_clone(Spawn_Settings.palce_1)
	Spawn_Settings.palce_12.group_id = 12
	Spawn_Settings.palce_12.position = {Vector3(-2120.24, -510.893, -800), Vector3(-2614.47, -681.511, -1000), Vector3(-2659.98, -528.267, -600)}
	table.insert(Spawn_Settings_List, "palce_12")
	
	Spawn_Settings.palce_13 = deep_clone(Spawn_Settings.palce_1)
	Spawn_Settings.palce_13.group_id = 13
	Spawn_Settings.palce_13.position = {Vector3(-2756.3, -13.3883, -580), Vector3(-2555.04, -23.5455, -580), Vector3(-2301.34, -29.0375, -580)}
	table.insert(Spawn_Settings_List, "palce_13")
	
	local _other_position = {Vector3(-4177, 401, 1), Vector3(-2864, 417, -673), Vector3(-4772, 1951, -698), Vector3(-4697, 4597, -698), Vector3(1625.06, 2986.7, -381)}

	Spawn_Settings.other_001 = deep_clone(Spawn_Settings.palce_1)
	Spawn_Settings.other_001.group_id = 14
	Spawn_Settings.other_001.position = _other_position
	Spawn_Settings.other_001.POSNOADD = true
	table.insert(Spawn_Settings_List, "other_001")
	
	Spawn_Settings.other_002 = deep_clone(Spawn_Settings.palce_1)
	Spawn_Settings.other_002.group_id = 15
	Spawn_Settings.other_002.position = _other_position
	Spawn_Settings.other_002.POSNOADD = true
	table.insert(Spawn_Settings_List, "other_002")
	
	Spawn_Settings.other_003 = deep_clone(Spawn_Settings.palce_1)
	Spawn_Settings.other_003.group_id = 16
	Spawn_Settings.other_003.position = _other_position
	Spawn_Settings.other_003.POSNOADD = true
	table.insert(Spawn_Settings_List, "other_003")
	
	ShadowRaidLoud.Spawn_Settings = deep_clone(Spawn_Settings)
	ShadowRaidLoud.Spawn_Settings_List = Spawn_Settings_List
	
	Spawn_Settings = {}
	Spawn_Settings_List = {}
	_default_enemy = {}

--Spawning_Other
	ShadowRaidLoud.Spawning_Other = {
		sniper = {pos = {Vector3(-3108, 3658, 608), Vector3(-3125, 3430, 608), Vector3(-3149, 3087, 607), Vector3(-3177, 2682, 606), Vector3(-3208, 2248, 605), Vector3(-3230, 1937, 604)}},
		taser = {amount = 1, name = {Idstring("units/payday2/characters/ene_tazer_1/ene_tazer_1")}},
		shield = {amount = 3, name = {Idstring("units/payday2/characters/ene_shield_1/ene_shield_1")}},
		spooc = {amount = 1, name = {Idstring("units/payday2/characters/ene_spook_1/ene_spook_1")}},
		tank = {amount = 1, name = {Idstring("units/payday2/characters/ene_bulldozer_1/ene_bulldozer_1")}},
		
		pos_default = {},
	}
	if _D ~= "easy" and _D ~= "normal" then
		table.insert(ShadowRaidLoud.Spawning_Other.shield.name, Idstring("units/payday2/characters/ene_shield_2/ene_shield_2"))
		table.insert(ShadowRaidLoud.Spawning_Other.tank.name, Idstring("units/payday2/characters/ene_bulldozer_2/ene_bulldozer_2"))
	end
	if _D == "overkill_290" then
		table.insert(ShadowRaidLoud.Spawning_Other.tank.name, Idstring("units/payday2/characters/ene_bulldozer_3/ene_bulldozer_3"))
	end

	for _, v in pairs(ShadowRaidLoud.Spawn_Settings) do
		if not v.POSNOADD then
			for _, pos in pairs(v.position) do
				table.insert(ShadowRaidLoud.Spawning_Other.pos_default, pos)
				table.insert(ShadowRaidLoud.Spawning_Other.sniper.pos, pos)
			end
		end
	end	
	
	for _, v in pairs(_other_position) do
		table.insert(ShadowRaidLoud.Spawning_Other.sniper.pos, v)
		table.insert(ShadowRaidLoud.Spawning_Other.pos_default, v)
	end
	
	_other_position = {}
	
function ShadowRaidLoud:Announce(msg)
	managers.chat:send_message(ChatManager.GAME, "" , msg or "")
end

function set_team(unit)
	local team = unit:base():char_tweak().access == "gangster" and "gangster" or "combatant"
	local AIState = managers.groupai:state()
	local team_id = tweak_data.levels:get_default_team_ID(team)
	unit:movement():set_team(AIState:team_data(team_id))
end

function ShadowRaidLoud:_full_function_spawn(name, pos, rot, delay)
	delay = delay or 1
	local _nowslot = math.random(1, 100)
	DelayedCalls:Add("DelayedCalls_ShadowRaidLoud_full_function_spawn_" .. _nowslot, delay, function()
		local _player_unit = {}
		for _, data in pairs(managers.groupai:state():all_criminals() or {}) do
			table.insert(_player_unit, data.unit)
		end
		local _final_unit_to_use = _player_unit[math.random(table.size(_player_unit))] or {}
		local new_objective = {
				type = "follow",
				follow_unit = _final_unit_to_use,
				scan = true,
				is_default = true
			}
		pos = pos + Vector3(0, 0, 10)
		local _u = World:spawn_unit(name, pos, rot)
		set_team(_u)
		_u:brain():set_spawn_ai( { init_state = "idle", params = { scan = true }, objective = new_objective } )
		_u:brain():action_request( { type = "act", body_part = 1, variant = "idle", align_sync = true } )
		_u:brain():on_reload()
		_u:movement():set_character_anim_variables()
	end)
end