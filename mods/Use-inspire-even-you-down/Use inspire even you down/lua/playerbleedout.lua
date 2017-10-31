function PlayerBleedOut:_Hack_Inspire(t)
	local skip_alert = managers.groupai:state():whisper_mode()
	if not skip_alert then
		local voice_type, plural, prime_target = self:_get_unit_intimidation_action(true, true, true, false, true, nil, nil, nil)
		if voice_type == "come" or voice_type == "revive" then		
			local is_human_player, record = false, {}
			record = managers.groupai:state():all_criminals()[prime_target.unit:key()]
			if record.ai then
				if not prime_target.unit:brain():player_ignore() then
					prime_target.unit:movement():set_cool(false)
					prime_target.unit:brain():on_long_dis_interacted(0, self._unit, secondary)
				end
			else
				is_human_player = true
			end			
			local amount = 0
			local rally_skill_data = self._ext_movement:rally_skill_data()
			if rally_skill_data and rally_skill_data.range_sq > mvector3.distance_sq(self._pos, record.m_pos) then
				local needs_revive, is_arrested, action_stop
				if not secondary then
					if prime_target.unit:base().is_husk_player then
						is_arrested = prime_target.unit:movement():current_state_name() == "arrested"
						needs_revive = prime_target.unit:interaction():active() and prime_target.unit:movement():need_revive() and not is_arrested
					else
						is_arrested = prime_target.unit:character_damage():arrested()
						needs_revive = prime_target.unit:character_damage():need_revive()
					end
					if needs_revive and managers.player:has_enabled_cooldown_upgrade("cooldown", "long_dis_revive") then
						voice_type = "revive"
						managers.player:disable_cooldown_upgrade("cooldown", "long_dis_revive")
					elseif not is_arrested and not needs_revive and rally_skill_data.morale_boost_delay_t and managers.player:player_timer():time() > rally_skill_data.morale_boost_delay_t then
						voice_type = "boost"
						amount = 1
					end
				end
			end
			if is_human_player then
				prime_target.unit:network():send_to_unit({
					"long_dis_interaction",
					prime_target.unit,
					amount,
					self._unit,
					secondary or false
				})
			end
			if not voice_type then
				if secondary then
				else
					voice_type = "ai_stay" and "come"
				end
			end
			plural = false			
			if voice_type == "revive" then
				interact_type = "cmd_get_up"
				local static_data = managers.criminals:character_static_data_by_unit(prime_target.unit)
				if not static_data then
					return
				end
				sound_name = "f36x_any"
				if math.random() < self._ext_movement:rally_skill_data().revive_chance then
					prime_target.unit:interaction():interact(self._unit)
				end
				self._ext_movement:rally_skill_data().morale_boost_delay_t = managers.player:player_timer():time() + (self._ext_movement:rally_skill_data().morale_boost_cooldown_t or 3.5)
				self:_do_action_intimidate(t, interact_type, sound_name, skip_alert)
				return true
			end
		end
	end
	return false
end

function PlayerBleedOut:_check_action_interact(t, input)
	if input.btn_interact_press and (not self._intimidate_t or t - self._intimidate_t > tweak_data.player.movement_state.interaction_delay) then
		self._intimidate_t = t
		local _bool = self:_Hack_Inspire(t)
		if not _bool and not PlayerArrested.call_teammate(self, "f11", t) then
			self:call_civilian("f11", t, false, true, self._revive_SO_data)
		end
	end
end