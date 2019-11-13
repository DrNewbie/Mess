Hooks:PostHook(PlayerStandard, "_update_equip_weapon_timers", "F_"..Idstring("PlayerStandard:_update_equip_weapon_timers:mod that automatically refill minigun gun amm"):key(), function(self)
	if self._equipped_unit and alive(self._equipped_unit) and self._equipped_unit:base() and self._equipped_unit:base()._is_auto_refill_minigun and self._equipped_unit:base()._auto_refill_minigun_ask_forced_reload and self._equipped_unit:base()._auto_refill_minigun_ask_forced_reload < TimerManager:game():time() then
		self._equipped_unit:base()._auto_refill_minigun_ask_forced_reload = nil
		if self._equipped_unit:base():can_reload() then
			self._equipped_unit:base():on_reload()
			managers.hud:set_ammo_amount(self._equipped_unit:base():selection_index(), self._equipped_unit:base():ammo_info())
		end
	end
end)