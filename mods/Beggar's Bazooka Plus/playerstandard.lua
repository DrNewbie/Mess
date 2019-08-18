Hooks:PostHook(PlayerStandard, "_start_action_equip", "F_"..Idstring("PlayerStandard:_start_action_equip:BB"):key(), function(self)
	if self._equipped_unit and self._equipped_unit:base() and self._equipped_unit:base()._is_beggars_bazooka and not self._equipped_unit:base()._is_beggars_bazooka_check then
		local weapon = self._equipped_unit:base()
		weapon._is_beggars_bazooka_check = true
		weapon._projectile_type = 'west_arrow_exp'
		weapon:weapon_tweak_data().projectile_type = weapon._projectile_type
		if weapon._ammo_data and weapon._ammo_data.launcher_grenade then
			weapon._ammo_data.launcher_grenade = weapon._projectile_type
		end
		weapon:on_reload()
		self._BB_rld = false
		self._BB_ready = {}
		self._BB_hold = nil
		managers.player:Set_BB(0)
	end
end)

Hooks:PostHook(PlayerStandard, "_check_action_reload", "F_"..Idstring("PlayerStandard:_check_action_reload:BB"):key(), function(self, t, input)
	local mT = TimerManager:game():time()
	if not self._BB_hold then
		if self._equipped_unit and self._equipped_unit:base() and self._equipped_unit:base()._is_beggars_bazooka then
			if not input.btn_primary_attack_release and input.btn_primary_attack_state then
				if self:_is_reloading() then
					self._BB_rld = true
				else
					if self._BB_rld then
						self._BB_rld = false
						self._equipped_unit:base():add_ammo_to_pool(-1, self._equipped_unit:base():selection_index())
						managers.player:Add_BB(1)
						self:_start_action_reload_enter(t)
						if managers.player:Get_BB() > 3 then
							managers.player:Add_BB(-1)
							self._BB_ready[Idstring(tostring(mT)):key()] = {
								t = mT - 0.1,
								u_unit = self._equipped_unit,
								dir = Vector3(0, 0, -1)
							}
						end
					end
				end
			else
				if managers.player:Get_BB() > 0 then
					local BB = managers.player:Get_BB()
					managers.player:Set_BB(0)
					if self._equipped_unit:base() then
						for iB = 1, BB do
							local dd_t = mT + 0.25 * (iB - 1)
							self._BB_ready[Idstring(tostring(iB)):key()] = {
								t = dd_t,
								u_unit = self._equipped_unit
							}
							self._BB_hold = dd_t + 0.25
						end
					end
				end
			end
		end
	else
		if self._BB_hold < mT then
			self._BB_hold = nil
		end
	end
end)

Hooks:PostHook(PlayerStandard, "update", "F_"..Idstring("PlayerStandard:update:BB"):key(), function(self, t)
	if self._BB_ready then
		for kkey, d in pairs(self._BB_ready) do
			if d and d.t and type(d.t) == "number" and TimerManager:game():time() >= d.t then
				self._BB_ready[kkey] = nil
				if self._equipped_unit == d.u_unit then
					local dir = self._unit:movement():m_head_rot():y()
					self._equipped_unit:base():_fire_sound()
					self._equipped_unit:base():_fire_raycast(self._unit, self:get_fire_weapon_position(), d.dir or dir, 1, nil, 1.15)
				end
			end
		end
	end
end)