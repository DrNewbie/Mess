local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local pairs = pairs
local math_clamp = math.clamp
local math_lerp = math.lerp
local math_random = math.random
local math_min = math.min

local REACT_AIM = AIAttentionObject.REACT_AIM
local REACT_COMBAT = AIAttentionObject.REACT_COMBAT
local REACT_IDLE = AIAttentionObject.REACT_IDLE
local REACT_SHOOT = AIAttentionObject.REACT_SHOOT
local REACT_SPECIAL_ATTACK = AIAttentionObject.REACT_SPECIAL_ATTACK

local cops_to_intimidate = {}
local grace_period = 10
local local_player_has_chico_preferred_target
local default_reaction_func = CopLogicIdle._chk_reaction_to_attention_object
local _is_vr = _G.IS_VR

function CopLogicIdle.fs_chk_reaction_to_attention_object(data, attention_data)
	local record = attention_data.criminal_record
	local can_arrest = CopLogicBase._can_arrest(data)

	if not record or not attention_data.is_person then
		if attention_data.settings.reaction == AIAttentionObject.REACT_ARREST and not can_arrest then
			return REACT_COMBAT
		else
			return attention_data.settings.reaction
		end
	end

	local att_unit = attention_data.unit

	if attention_data.is_deployable or data.t < record.arrest_timeout then
		return REACT_COMBAT
	end

	local visible = attention_data.verified

	if record.status == 'dead' then
		return math_min(attention_data.settings.reaction, REACT_AIM)

	elseif record.status == 'disabled' then
		if record.assault_t and record.assault_t - record.disabled_t > 0.6 then
			return math_min(attention_data.settings.reaction, REACT_COMBAT)
		else
			return math_min(attention_data.settings.reaction, REACT_AIM)
		end

	elseif record.being_arrested then
		return math_min(attention_data.settings.reaction, REACT_AIM)

	elseif can_arrest and (not record.assault_t or att_unit:base():arrest_settings().aggression_timeout < data.t - record.assault_t) and record.arrest_timeout < data.t and not record.status then
		local under_threat = nil

		if attention_data.dis < 2000 then
			for u_key, other_crim_rec in pairs(managers.groupai:state():all_criminals()) do
				local other_crim_attention_info = data.detected_attention_objects[u_key]

				if other_crim_attention_info and (other_crim_attention_info.is_deployable or other_crim_attention_info.verified and other_crim_rec.assault_t and data.t - other_crim_rec.assault_t < other_crim_rec.unit:base():arrest_settings().aggression_timeout) then
					under_threat = true
					break
				end
			end
		end

		if under_threat then
			-- Nothing
		elseif attention_data.dis < 2000 and visible then
			return math_min(attention_data.settings.reaction, AIAttentionObject.REACT_ARREST)
		else
			return REACT_AIM
		end
	end

	return REACT_COMBAT
end

local function SetLoud()
	local_player_has_chico_preferred_target = managers.player:upgrade_value('player', 'chico_preferred_target', false)
	if type(BB) == 'table' then
		cops_to_intimidate = BB.cops_to_intimidate or {}
		grace_period = BB.grace_period
	else
		cops_to_intimidate = FullSpeedSwarm.cops_to_intimidate
	end
	if FullSpeedSwarm.final_settings.nervous_game then
		default_reaction_func = CopLogicIdle.fs_chk_reaction_to_attention_object
	end
end
table.insert(FullSpeedSwarm.call_on_loud, SetLoud)

function CopLogicIdle._get_priority_attention(data, attention_objects, reaction_func)
	local t = data.t
	reaction_func = reaction_func or default_reaction_func
	local best_target, best_target_priority_slot, best_target_priority, best_target_reaction

	local gstate = managers.groupai:state()
	local forced_attention_data = gstate:force_attention_data(data.unit)
	if forced_attention_data then
		if data.attention_obj and data.attention_obj.unit == forced_attention_data.unit then
			return data.attention_obj, 1, REACT_SHOOT
		end
		local u_key = forced_attention_data.unit:key()
		local attention_info = gstate._attention_objects.all[u_key]
		if attention_info then
			if forced_attention_data.ignore_vis_blockers then
				local vis_ray = World:raycast('ray', data.unit:movement():m_head_pos(), attention_info.handler:get_detection_m_pos(), 'slot_mask', data.visibility_slotmask, 'ray_type', 'ai_vision')
				if type(vis_ray) ~= 'table' or vis_ray.unit:key() == u_key or not vis_ray.unit:visible() then
					best_target = CopLogicBase._create_detected_attention_object_data(t, data.unit, u_key, attention_info, attention_info.handler:get_attention(data.SO_access), true)
					best_target.verified = true
				end
			else
				best_target = CopLogicBase._create_detected_attention_object_data(t, data.unit, u_key, attention_info, attention_info.handler:get_attention(data.SO_access), true)
			end
		end
		if best_target then
			return best_target, 1, REACT_SHOOT
		end
	end

	for u_key, attention_data in pairs(attention_objects) do
		local settings = attention_data.settings
		if attention_data.stare_expire_t then
			if t > attention_data.stare_expire_t then
				if attention_data.stare_step_2 then
					if not settings.attract_chance or math_random() < settings.attract_chance then
						attention_data.stare_expire_t = nil
						attention_data.stare_step_2 = nil
					else
						attention_data.stare_expire_t = t + math_lerp(settings.pause[1], settings.pause[2], math_random())
					end
				else
					local pause = settings.pause
					if pause then
						attention_data.stare_expire_t = t + math_lerp(pause[1], pause[2], math_random())
						attention_data.stare_step_2 = true
					else
						attention_data.stare_expire_t = nil
					end
				end
			end

		elseif attention_data.identified then
			local crim_record = attention_data.criminal_record
			local status = crim_record and crim_record.status

			-- once combat engaged, no need to reevaluate in most cases
			local reaction
			if settings == attention_data.previous_settings then
				reaction = REACT_COMBAT
			else
				reaction = reaction_func(data, attention_data, not CopLogicAttack._can_move(data))
				if reaction == REACT_COMBAT and data._tweak_table ~= 'taser' then
					attention_data.previous_settings = settings
				end
			end

			local att_unit = attention_data.unit
			if data.cool and reaction >= AIAttentionObject.REACT_SCARED then
				data.unit:movement():set_cool(false, gstate.analyse_giveaway(data._tweak_table, att_unit))
			end

			local reaction_too_mild
			local distance = attention_data.dis
			if not reaction or best_target_reaction and best_target_reaction > reaction then
				reaction_too_mild = true
			elseif distance < 150 and reaction == REACT_IDLE then
				reaction_too_mild = true
			end

			if not reaction_too_mild then
				local free_status = status == nil
				local weight_mul = settings.weight_mul or 1
				local reviving
				local aum = att_unit:movement()
				if attention_data.is_local_player then
					local managers_player = managers.player
					local current_state = aum._current_state
					if not current_state._moving and current_state:ducking() then
						weight_mul = weight_mul * managers_player:upgrade_value('player', 'stand_still_crouch_camouflage_bonus', 1)
					end
					if local_player_has_chico_preferred_target and managers_player:has_activate_temporary_upgrade('temporary', 'chico_injector') then
						weight_mul = weight_mul * 1000
					end
					if _is_vr and tweak_data.vr.long_range_damage_reduction_distance[1] < distance then
						local mul = math_clamp((distance / tweak_data.vr.long_range_damage_reduction_distance[2]) / 2, 0, 1) + 1
						weight_mul = weight_mul * mul
					end

					local interact_params = current_state._interact_params
					if interact_params and interact_params.tweak_data == 'revive' then
						reviving = true
					end
				else
					local aub = att_unit:base()
					if aub then
						if aum then
							if not aum._move_data and aum._pose_code == 2 then
								weight_mul = weight_mul * (aub:upgrade_value('player', 'stand_still_crouch_camouflage_bonus') or 1)
							end
							if aum.is_vr and aum:is_vr() and tweak_data.vr.long_range_damage_reduction_distance[1] < distance then
								local mul = math_clamp((distance / tweak_data.vr.long_range_damage_reduction_distance[2]) / 2, 0, 1) + 1
								weight_mul = weight_mul * mul
							end
						end

						if aub.has_activate_temporary_upgrade and aub:has_activate_temporary_upgrade('temporary', 'chico_injector') then
							if aub:upgrade_value('player', 'chico_preferred_target') then
								weight_mul = weight_mul * 1000
							end
						end
					end

					local uad = att_unit:anim_data()
					reviving = uad and uad.revive
				end

				local target_priority = distance
				local target_priority_slot = 0
				if attention_data.verified and not reviving then
					local alert_dt = attention_data.alert_t and t - attention_data.alert_t or 10000
					local dmg_dt = attention_data.dmg_t and t - attention_data.dmg_t or 10000
					if weight_mul ~= 1 then
						distance = distance / weight_mul
						dmg_dt = dmg_dt / weight_mul
						alert_dt = alert_dt / weight_mul
					end

					if distance < 500 then
						target_priority_slot = 2
					elseif distance < 1500 then
						target_priority_slot = 4
					else
						target_priority_slot = 6
					end

					if dmg_dt < 5 then -- has_damaged
						target_priority_slot = target_priority_slot - 2
					elseif alert_dt < 3.5 then -- has_alerted
						target_priority_slot = target_priority_slot - 1
					elseif free_status and reaction == REACT_SPECIAL_ATTACK then -- assault_reaction
						target_priority_slot = 5
					end

					local attention_obj = data.attention_obj
					if attention_obj and attention_obj.u_key == u_key and t - attention_data.acquire_t < 4 then -- old_enemy
						target_priority_slot = target_priority_slot - 3
					end
					target_priority_slot = math_clamp(target_priority_slot, 1, 10)
				elseif free_status then
					target_priority_slot = 7
				end

				if reaction < REACT_COMBAT then
					target_priority_slot = 10 + target_priority_slot + REACT_COMBAT - reaction
				end

				if target_priority_slot ~= 0 then
					local best = false
					if not best_target then
						best = true
					elseif best_target_priority_slot > target_priority_slot then
						best = true
					elseif target_priority_slot == best_target_priority_slot and best_target_priority > target_priority then
						best = true
					end
					if best and not (cops_to_intimidate[u_key] and t - cops_to_intimidate[u_key] < grace_period) then
						best_target = attention_data
						best_target_reaction = reaction
						best_target_priority_slot = target_priority_slot
						best_target_priority = target_priority
					end
				end
			end
		end
	end

	return best_target, best_target_priority_slot, best_target_reaction
end

function CopLogicIdle.queued_update(data)
	local my_data = data.internal_data
	local delay = data.logic._upd_enemy_detection(data)
	if data.internal_data ~= my_data then
		CopLogicBase._report_detections(data.detected_attention_objects)
		return
	end
	local objective = data.objective
	if my_data.has_old_action then
		CopLogicIdle._upd_stop_old_action(data, my_data, objective)
		CopLogicBase.queue_task(my_data, my_data.detection_task_key, CopLogicIdle.queued_update, data, data.t + delay, data.important and true)
		return
	end
	if data.team.id == 'criminal1' and (not data.objective or data.objective.type == 'free') then
		if not data.path_fail_t or data.t - data.path_fail_t > 6 then
			managers.groupai:state():on_criminal_jobless(data.unit)
			if my_data ~= data.internal_data then
				return
			end
		end
	end
	if CopLogicIdle._chk_exit_non_walkable_area(data) then
		return
	end
	if CopLogicIdle._chk_relocate(data) then
		return
	end
	CopLogicIdle._perform_objective_action(data, my_data, objective)
	CopLogicIdle._upd_stance_and_pose(data, my_data, objective)
	CopLogicIdle._upd_pathing(data, my_data)
	CopLogicIdle._upd_scan(data, my_data)
	if data.cool then
		CopLogicIdle.upd_suspicion_decay(data)
	end
	if data.internal_data ~= my_data then
		CopLogicBase._report_detections(data.detected_attention_objects)
		return
	end
	delay = data.important and 0.1 or delay or 0.3
	CopLogicBase.queue_task(my_data, my_data.detection_task_key, CopLogicIdle.queued_update, data, data.t + delay, data.important and true)
end

local fs_original_coplogicidle_onintimidated = CopLogicIdle.on_intimidated
function CopLogicIdle.on_intimidated(data, ...)
	if data.char_tweak.surrender and data.char_tweak.surrender ~= tweak_data.character.presets.special then
		cops_to_intimidate[data.unit:key()] = TimerManager:game():time()
	end
	return fs_original_coplogicidle_onintimidated(data, ...)
end
