Hooks:PostHook(PlayerDamage, "update", "BoomEventGetT", function(self, unit, t)	
	if self._push_now then
		local attack_data = self._push_now
		self._push_now = nil
		local PlyStandard = self._unit and alive(self._unit) and self._unit:movement() and self._unit:movement()._states.standard or nil
		if PlyStandard then
			PlyStandard:_start_rocket_jump(t + 0.1, attack_data)
		end
	end
end)

Hooks:PostHook(PlayerDamage, "damage_explosion", "BoomEventAndPush", function(self, attack_data)
	if not self:_chk_can_take_dmg() then
		return
	end

	local damage_info = {result = {
		variant = "explosion",
		type = "hurt"
	}}

	if self._god_mode or self._invulnerable or self._mission_damage_blockers.invulnerable then
		self:_call_listeners(damage_info)

		return
	elseif self._unit:movement():current_state().immortal then
		return
	elseif self:incapacitated() then
		return
	end

	local distance = mvector3.distance(attack_data.position, self._unit:position())

	if attack_data.range < distance then
		return
	end

	local damage = (attack_data.damage or 1) * (1 - distance / attack_data.range)

	if self._bleed_out then
		return
	end
	
	if damage * 10 < 15 then
		return
	end
	
	self._push_now = {
		dis_vec = (self._unit:position() - attack_data.position),
		damage = damage
	}
end)