Hooks:PostHook(TeamAIDamage, "damage_bullet", "HurtMyAI_damage_bullet", function(self, attack_data)
	if PlayerDamage.is_friendly_fire(self, attack_data.attacker_unit) and not managers.groupai:state():is_unit_team_AI(attack_data.attacker_unit) then
		local result = {
			type = "none",
			variant = "bullet"
		}
		attack_data.result = result
		if self:_cannot_take_damage() then
			return
		end
		attack_data.damage = attack_data.damage * 5
		local damage_percent, health_subtracted = self:_apply_damage(attack_data, result)
		local t = TimerManager:game():time()
		self._next_allowed_dmg_t = t + self._dmg_interval
		self._last_received_dmg_t = t
		self._last_received_dmg = health_subtracted
		if health_subtracted > 0 then
			self:_send_damage_drama(attack_data, health_subtracted)
		end
		if self._dead then
			self:_unregister_unit()
		end
		self:_call_listeners(attack_data)
		self:_send_bullet_attack_result(attack_data)
	end
end)

Hooks:PostHook(TeamAIDamage, "damage_melee", "HurtMyAI_damage_melee", function(self, attack_data)
	if PlayerDamage.is_friendly_fire(self, attack_data.attacker_unit) and not managers.groupai:state():is_unit_team_AI(attack_data.attacker_unit) then
		if self._invulnerable or self._dead or self._fatal or self._arrested_timer then
			return
		end
		local result = {variant = "melee"}
		attack_data.damage = attack_data.damage * 5
		local damage_percent, health_subtracted = self:_apply_damage(attack_data, result)
		local t = TimerManager:game():time()
		self._next_allowed_dmg_t = t + self._dmg_interval
		self._last_received_dmg_t = t
		if health_subtracted > 0 then
			self:_send_damage_drama(attack_data, health_subtracted)
		end
		if self._dead then
			self:_unregister_unit()
		end
		self:_call_listeners(attack_data)
		self:_send_melee_attack_result(attack_data)
	end
end)

Hooks:PostHook(TeamAIDamage, "damage_explosion", "HurtMyAI_damage_explosion", function(self, attack_data)
	if PlayerDamage.is_friendly_fire(self, attack_data.attacker_unit) and not managers.groupai:state():is_unit_team_AI(attack_data.attacker_unit) then
		if self:_cannot_take_damage() then
			return
		end
		local attacker_unit = attack_data.attacker_unit
		if attacker_unit and attacker_unit:base() and attacker_unit:base().thrower_unit then
			attacker_unit = attacker_unit:base():thrower_unit()
		end
		local result = {variant = attack_data.variant}
		attack_data.damage = attack_data.damage * 5
		local damage_percent, health_subtracted = self:_apply_damage(attack_data, result)
		if health_subtracted > 0 then
			self:_send_damage_drama(attack_data, health_subtracted)
		end
		if self._dead then
			self:_unregister_unit()
		end
		self:_call_listeners(attack_data)
		self:_send_explosion_attack_result(attack_data)
	end
end)

Hooks:PostHook(TeamAIDamage, "damage_fire", "HurtMyAI_damage_fire", function(self, attack_data)
	if PlayerDamage.is_friendly_fire(self, attack_data.attacker_unit) and not managers.groupai:state():is_unit_team_AI(attack_data.attacker_unit) then
		if self:_cannot_take_damage() then
			return
		end
		local attacker_unit = attack_data.attacker_unit
		if attacker_unit and alive(attacker_unit) and attacker_unit:base() and attacker_unit:base().thrower_unit then
			attacker_unit = attacker_unit:base():thrower_unit()
		end
		if attacker_unit and not alive(attacker_unit) then
			return
		end
		local result = {variant = attack_data.variant}
		attack_data.damage = attack_data.damage * 5
		local damage_percent, health_subtracted = self:_apply_damage(attack_data, result)
		if health_subtracted > 0 then
			self:_send_damage_drama(attack_data, health_subtracted)
		end
		if self._dead then
			self:_unregister_unit()
		end
		self:_call_listeners(attack_data)
		self:_send_fire_attack_result(attack_data)
	end
end)

Hooks:PostHook(TeamAIDamage, "damage_tase", "HurtMyAI_damage_tase", function(self, attack_data)
	if PlayerDamage.is_friendly_fire(self, attack_data.attacker_unit) and not managers.groupai:state():is_unit_team_AI(attack_data.attacker_unit) then
		if self:_cannot_take_damage() then
			return
		end
		self._regenerate_t = nil
		local damage_info = {
			variant = "tase",
			result = {type = "hurt"}
		}
		if self._tase_effect then
			World:effect_manager():fade_kill(self._tase_effect)
		end
		self._tase_effect = World:effect_manager():spawn(self._tase_effect_table)
		if Network:is_server() then
			if math.random() < 0.25 then
				self._unit:sound():say("s07x_sin", true)
			end
			if not self._to_incapacitated_clbk_id then
				self._to_incapacitated_clbk_id = "TeamAIDamage_to_incapacitated" .. tostring(self._unit:key())
				managers.enemy:add_delayed_clbk(self._to_incapacitated_clbk_id, callback(self, self, "clbk_exit_to_incapacitated"), TimerManager:game():time() + self._char_dmg_tweak.TASED_TIME)
			end
		end
		self:_call_listeners(damage_info)
		if Network:is_server() then
			self:_send_tase_attack_result()
		end
	end
end)