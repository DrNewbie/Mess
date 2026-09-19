Hooks:PostHook(PlayerStandard, "_update_equip_weapon_timers", "F_"..Idstring("PlayerStandard:_update_equip_weapon_timers:DewmSlayaLASBoosts"):key(), function(self)
	if managers.player:Is_LAS_DewmSlaya() and self._equipped_unit and alive(self._equipped_unit) and self._equipped_unit:base() and self._equipped_unit:base()._is_dewmslaya then
		if not self._equipped_unit:base()._is_dewmslaya_init then
			self._equipped_unit:base()._is_dewmslaya_init = true
			self._equipped_unit:base():on_reload()
			managers.hud:set_ammo_amount(self._equipped_unit:base():selection_index(), self._equipped_unit:base():ammo_info())
		end
		if self._equipped_unit:base()._ask_forced_reload then
			if self._equipped_unit:base()._ask_forced_reload < TimerManager:game():time() then
				self._equipped_unit:base()._ask_forced_reload = nil
				if self._equipped_unit:base():can_reload() then
					self._equipped_unit:base():on_reload()
					managers.hud:set_ammo_amount(self._equipped_unit:base():selection_index(), self._equipped_unit:base():ammo_info())
				end
			end
		end
	end
end)