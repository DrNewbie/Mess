local Ply_init_ask_bot_use_min_equipment = false

Hooks:PostHook(PlayerStandard, "init", "BotMiniDeployable_PlayerStandard_init", function(self)
	if Input and Input:keyboard() and not Ply_init_ask_bot_use_min_equipment then
		Ply_init_ask_bot_use_min_equipment = true
		Input:keyboard():add_trigger(Idstring("f8"), callback(self, self, "Ask_Bot_Us_Min_Equipment"))
		self._ask_bot_t = 0
	end
end)

function PlayerStandard:Ask_Bot_Us_Min_Equipment()
	if managers.player:player_unit():movement()._current_state_name ~= "standard" then
		return
	end
	self._ask_bot = true
	self:_start_ask_bot(TimerManager:game():time())
end

function PlayerStandard:_start_ask_bot(t)
	if self._ask_bot then
		self._ask_bot = false
		if t > self._ask_bot_t then
			self._ask_bot_t = t + 5
			local secondary
			local skip_alert = managers.groupai:state():whisper_mode()
			local voice_type, plural, prime_target = self:_get_unit_intimidation_action(not secondary, not secondary, true, false, true, nil, nil, nil, secondary)
			if prime_target and prime_target.unit and prime_target.unit.base and (prime_target.unit:base().unintimidateable or prime_target.unit:anim_data() and prime_target.unit:anim_data().unintimidateable) then
				return
			end
			if not prime_target or not prime_target.unit or not prime_target.unit:inventory() or not prime_target.unit:inventory().min_equipment_amount or not prime_target.unit:inventory():min_equipment_amount() > 0 then
				return
			end
			local min_equipment = prime_target.unit:inventory():min_equipment() or nil
			if min_equipment then
				local unit_min, pos, rot
				pos = prime_target.unit:position()
				rot = prime_target.unit:rotation()				
				if min_equipment == "ammo_bag" then
					unit_min = AmmoBagBase.spawn(pos, rot, 0, 0, 0)
				elseif min_equipment == "doctor_bag" then
					unit_min = DoctorBagBase.spawn(pos, rot, 0, 0)
				end
				if unit_min and alive(unit_min) then
					prime_target.unit:inventory():reduce_min_equipment_amount(true)
					unit_min:base():set_min(true)
					self:say_line("g18", skip_alert)
					if prime_target.unit:inventory():min_equipment_amount() <= 0 then
						local visual_object = tweak_data.equipments[min_equipment] and tweak_data.equipments[min_equipment].visual_object
						local mesh_obj = prime_target.unit:get_object(Idstring(visual_object))
						if mesh_obj then
							mesh_obj:set_visibility(false)
						end
					end
				end
			end
		end
	end
end