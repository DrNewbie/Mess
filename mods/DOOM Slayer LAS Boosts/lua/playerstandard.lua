Hooks:PostHook(PlayerStandard, "_update_equip_weapon_timers", "F_"..Idstring("PlayerStandard:_update_equip_weapon_timers:DewmSlayaLASBoosts"):key(), function(self)
	if managers.player:Is_LAS_DewmSlaya() and self._equipped_unit and alive(self._equipped_unit) and self._equipped_unit:base() and self._equipped_unit:base()._is_dewmslaya and not self._equipped_unit:base()._is_dewmslaya_init then
		self._equipped_unit:base()._is_dewmslaya_init = true
		self._equipped_unit:base():on_reload()
		managers.hud:set_ammo_amount(self._equipped_unit:base():selection_index(), self._equipped_unit:base():ammo_info())
	end
end)