if Network:is_client() then
	return
end

_G.SurvivorModeBase = _G.SurvivorModeBase or {}

Hooks:Add("GameSetupUpdate", "SurvivorModeBaseGameSetupUpdate", function(t, dt)
	SurvivorModeBase:Timer_Main(t)
end)

SurvivorModeBase.Boss_Unit = nil
SurvivorModeBase.Bags_Reward_Time_Delay = 120
SurvivorModeBase.Bags_Reward_Give_Time = 0
SurvivorModeBase.Timer_Main_Delay = 0
SurvivorModeBase.Time_for_Next_Wave = false
SurvivorModeBase.Kill_This_Enemy = {}

function SurvivorModeBase:Timer_Main(t)
	if SurvivorModeBase.Timer_Main_Delay > t then
		return
	end

	local _nowtime = math.floor(t)
	
	SurvivorModeBase.Timer_Main_Delay = _nowtime + 1

	--Mission start
	if Utils:IsInHeist() and SurvivorModeBase and SurvivorModeBase.Enable then
		--Init
		if not SurvivorModeBase.Timer_Enable then
		--Do it once
			SurvivorModeBase.Timer_Enable = true
			SurvivorModeBase.Start_Time = _nowtime
			SurvivorModeBase.Bags_Reward_Give_Time = _nowtime + SurvivorModeBase.Bags_Reward_Time_Delay
		--Set Time Limit
			managers.groupai:state():set_point_of_no_return_timer(180, 0)
		--Forced Day 2
			if SurvivorModeBase.isDay1 then
				managers.job:set_next_interupt_stage("escape_park")
			end
		--Day 2 BOSS Fight
			DelayedCalls:Add( "DelayedCallsSurvivorModeBase_BOSS_Spawn", 10, function()
				if not SurvivorModeBase.isDay1 and SurvivorModeBase.Boss_Name then
					local _boss = Idstring(SurvivorModeBase.Boss_Name)
					local _unit = SurvivorModeBase:Spawn_Enemy(_boss, SurvivorModeBase.Boss_Position, SurvivorModeBase.Boss_Rotation)
					_unit:brain():set_active(true)
					SurvivorModeBase.Boss_Unit = _unit
					SurvivorModeBase.Boss_Killed = 1
					DelayedCalls:Add( "DelayedCallsSurvivorModeBase_BOSS_Fight", 10, function()
						SurvivorModeBase:talk2all("Kill the boss to active 'Escape Event'")
					end )
				end
			end )
		end
		--Next Wave
		local _kill_all_enemy = false
		if not SurvivorModeBase.Time_for_Next_Wave then
			SurvivorModeBase.Time_for_Next_Wave = true
			local for_next_wave = SurvivorModeBase.This_Time or 180
			local wave = SurvivorModeBase.This_Wave or 0
			managers.hud:Announce_Now_Wave(wave)
			SurvivorModeBase:Sync_Send("Sync_No_Return_Timer", 180)
			wave = wave + 1			
			SurvivorModeBase:Change_To_Next_Wave("arm_cro", wave, for_next_wave)
			_kill_all_enemy = true
		end
		--Give bag
		if t > SurvivorModeBase.Bags_Reward_Give_Time then
			SurvivorModeBase.Bags_Reward_Give_Time = _nowtime + SurvivorModeBase.Bags_Reward_Time_Delay
			SurvivorModeBase:Bags_Reward()
		end
		--Boss Check
		if SurvivorModeBase.Boss_Unit then
			if not alive(SurvivorModeBase.Boss_Unit) then
				SurvivorModeBase.Boss_Unit = nil
				SurvivorModeBase.Boss_Killed = 2
			else
				if _nowtime%3 == 0 then
					SurvivorModeBase.Boss_Unit:contour():add( "mark_enemy_damage_bonus" , true )
				end
			end
		end
		if SurvivorModeBase.Boss_Killed == 2 then
			if SurvivorModeBase.Day2Escape and SurvivorModeBase.Day2EscapeBlock == 1 then
				SurvivorModeBase.Day2EscapeBlock = 2
				if SurvivorModeBase.Day2Escape == 0 then
					SurvivorModeBase.Day2Escape = -1
				end
			end
		end
		if SurvivorModeBase.Day2Escape > 0 and SurvivorModeBase.Day2EscapeBlock == 2 then
			local _id = SurvivorModeBase.Day2Escape
			local _element = SurvivorModeBase.Day2Escape_Element
			local _instigator = SurvivorModeBase.Day2Escape_Instigator
			local _mission_script = SurvivorModeBase.Day2Escape_Mission_Script
			managers.network:session():send_to_peers_synched("run_mission_element_no_instigator", _id, 0)
			_mission_script:add(callback(_element, _element, "on_executed", _instigator), 1, 1)
			SurvivorModeBase.Day2Escape = -1
			SurvivorModeBase.Day2Escape_Element = nil
			SurvivorModeBase.Day2Escape_Instigator = nil
			SurvivorModeBase.Day2Escape_Mission_Script = nil
			log("[SurvivorMode]: Escape Active , Day2Escape")
			SurvivorModeBase.Day2EscapeBlock = 3
		end
		--Normal Running
		SurvivorModeBase.Real_Time_Pass = _nowtime - SurvivorModeBase.Start_Time
		--Enemy Type Amount
		local _all_enemies = managers.enemy:all_enemies() or {}
		local _enemy_type_amount = {}
		for _, data in pairs(_all_enemies) do
			local enemyKey = tostring(data.unit:name():key())
			if not _enemy_type_amount[enemyKey] then
				_enemy_type_amount[enemyKey] = 1
			else
				_enemy_type_amount[enemyKey] = _enemy_type_amount[enemyKey] + 1
				local _MAX = SurvivorModeBase.Allow_Spawn_Max_Amount[enemyKey] or -1
				if (_enemy_type_amount[enemyKey] > _MAX and _MAX > 0) or _kill_all_enemy then
					table.insert(SurvivorModeBase.Kill_This_Enemy, data.unit)
				end
			end
		end
		--Kill This Enemy
		for k, v in pairs(SurvivorModeBase.Kill_This_Enemy or {}) do
			if SurvivorModeBase.Boss_Unit and v == SurvivorModeBase.Boss_Unit then
				--nope
			else
				if v and alive(v) and v:character_damage() then
					v:character_damage():damage_explosion({variant = "explosion", damage = 99999999999, attacker_unit = managers.player:player_unit(), col_ray = {ray = Vector3(1, 0, 0), position = v:position()}})
				end
				table.remove(SurvivorModeBase.Kill_This_Enemy, k)
			end
		end
		if #SurvivorModeBase.Kill_This_Enemy <= 0 then
			SurvivorModeBase.Kill_This_Enemy = {}
		end
		_kill_all_enemy = false
	end
end

function SurvivorModeBase:Spawn_Enemy(name, pos, rot)
	local _unit = World:spawn_unit(name, pos, rot)
	local team = _unit:base():char_tweak().access == "gangster" and "gangster" or "combatant"
	local AIState = managers.groupai:state()
	local team_id = tweak_data.levels:get_default_team_ID(team)
	_unit:movement():set_team(AIState:team_data(team_id))
	local _player_unit = {}
	for _, data in pairs(managers.groupai:state():all_criminals() or {}) do
		table.insert(_player_unit, data.unit)
	end
	local _final_unit_to_use = _player_unit[math.random(table.size(_player_unit))] or {}
	local new_objective = {
		type = "follow",
		follow_unit = _final_unit_to_use,
		called = true,
		destroy_clbk_key = false,
		scan = true
	}
	_unit:brain():set_spawn_ai( { init_state = "idle", params = { scan = true }, objective = new_objective } )
	_unit:movement():set_character_anim_variables()
	return _unit
end

function SurvivorModeBase:Bags_Reward()
	if Utils:IsInHeist() and SurvivorModeBase and SurvivorModeBase.Enable and SurvivorModeBase.isDay1 then
		managers.loot:secure("gold", 1)
		managers.loot:_check_triggers("report_only")
		managers.groupai:state():set_wave_mode("hunt")
	end
end