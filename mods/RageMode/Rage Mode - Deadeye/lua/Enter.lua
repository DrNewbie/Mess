_G.Rage_Special = _G.Rage_Special or {}
local _PlayerStandardupdate_Deadeye_Delay = 0
local _Shot_Need_To_Do_Delay = 0
Hooks:PostHook(PlayerStandard, "update", "PlayerStandardupdate_Deadeye", function(ply, t, dt)	
	if _PlayerStandardupdate_Deadeye_Delay > t then
		return
	end
	_PlayerStandardupdate_Deadeye_Delay = t + 0.05
	if Rage_Special.Rage_Stop and Rage_Special.Activating and not Rage_Special.Activating_Ready_to_End_RUN then
		local delta = 0
		local _timer = Rage_Special.Expire_Time - t
		delta = math.clamp(_timer / Rage_Special.Ready_Time, 0, 1)
		Rage_Special.Rage_Point = math.clamp((Rage_Special.Rage_Point_Max * delta), 0, Rage_Special.Rage_Point_Max)
		if Rage_Special.Rage_Point <= 0 then
			Rage_Special.Activating_Ready_to_End_RUN = true
			managers.hud:hide_interaction_bar()
			managers.hud:hide_progress_timer_bar()
		else
			if not Rage_Special.Block_SomeThing then
				Rage_Special.Block_SomeThing = true
				Rage_Special.Block_SomeThing_Time = t + Rage_Special.Ready_Time + 2
			end
			managers.hud:set_interaction_bar_width((Rage_Special.Ready_Time - _timer), Rage_Special.Ready_Time)
			local _col_ray = Get_Crosshair_Enemy()
			if _col_ray and _col_ray.unit and managers.enemy:is_enemy(_col_ray.unit) then
				_col_ray.unit:contour():add("mark_enemy", false)
				Rage_Special.Mark_List[_col_ray.unit:key()] = {col_ray = _col_ray, t = Rage_Special.Expire_Time + 1}
			end
			for _id, _data in pairs(Rage_Special.Mark_List) do
				if type(_data.t) == "number" and alive(_data.col_ray.unit) then
					_data.col_ray.unit:contour():add("mark_enemy", false)
				else
					Rage_Special.Mark_List[_id] =  {}
				end
			end
			Rage_Special.Shot_Need_To_Do = table.size(Rage_Special.Mark_List)
		end
	end
	local _real_health = ply._unit:character_damage():get_real_health()
	local weap_base = nil
	if ply._equipped_unit then
		weap_base = ply._equipped_unit:base()
	end
	if Rage_Special.Activating_Ready_to_End_RUN and weap_base and Rage_Special.Shot_Need_To_Do > 0 and t > _Shot_Need_To_Do_Delay then
		Rage_Special.Shot_Need_To_Do = Rage_Special.Shot_Need_To_Do - 1
		if _real_health > 0 then
			_Shot_Need_To_Do_Delay = t + 0.05
			local weap_tweak_data = tweak_data.weapon[weap_base:get_name_id()]
			local shake_multiplier = weap_tweak_data.shake[ply._state_data.in_steelsight and "fire_steelsight_multiplier" or "fire_multiplier"]
			ply._ext_camera:play_shaker("fire_weapon_rot", 1 * shake_multiplier)
			ply._ext_camera:play_shaker("fire_weapon_kick", 1 * shake_multiplier, 1, 0.15)
			weap_base:tweak_data_anim_play("fire", 1)
			weap_base:start_shooting()
			ply._camera_unit:base():start_shooting()
		end
		if Rage_Special.Shot_Need_To_Do < 0 then
			Rage_Special.Shot_Need_To_Do = 0
		end
	end
	if t > _Shot_Need_To_Do_Delay and Rage_Special.Activating_Ready_to_End_RUN and table.size(Rage_Special.Mark_List) > 0 and Rage_Special.Prepare_To_Stop == 0 then
		if weap_base then
			for _id, _data in pairs(Rage_Special.Mark_List) do
				if type(_data.t) == "number" and t > _data.t and alive(_data.col_ray.unit) and weap_base:fire_mode() == "single" then
					local hit_unit = _data.col_ray.unit
					if hit_unit:in_slot(8) and alive(hit_unit:parent()) then
						hit_unit = hit_unit:parent()
					end
					if _real_health > 0 then
						if hit_unit:character_damage() and hit_unit:character_damage().damage_bullet then
							local _action_data = {}
							_action_data.variant = "bullet"
							_action_data.damage = 1000
							_action_data.weapon_unit = ply._equipped_unit
							_action_data.attacker_unit = ply._unit
							_action_data.col_ray = _data.col_ray
							hit_unit:character_damage():damage_bullet(_action_data)
						end
					end
					Rage_Special.Mark_List[_id] = {}
					Rage_Special.Prepare_To_Stop = t + 0.05
				end
			end
		end
	end
	if Rage_Special.Block_SomeThing and t > Rage_Special.Block_SomeThing_Time then
		Rage_Special.Block_SomeThing = false
		Rage_Special.Block_SomeThing_Time = 0
	end
end)

function Get_Crosshair_Enemy()
	if not managers.player or not managers.player:player_unit() then
		return nil, 0
	end
	local camera = managers.player:player_unit():camera()
	local mvec_to = Vector3()
	local from_pos = camera:position()
	mvector3.set(mvec_to, camera:forward())
	mvector3.multiply(mvec_to, 20000)
	mvector3.add(mvec_to, from_pos)
	local _col_ray = World:raycast("ray", from_pos, mvec_to, "slot_mask", managers.slot:get_mask("enemies"))
	return _col_ray or nil
end