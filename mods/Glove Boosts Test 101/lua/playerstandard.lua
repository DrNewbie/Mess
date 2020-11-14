Hooks:PostHook(PlayerStandard, "_update_equip_weapon_timers", "F_"..Idstring("PlayerStandard:_update_equip_weapon_timers:Glove Boosts Test 101"):key(), function(self)
	if managers.player:Is_Glove_Saints() and self._equipped_unit and alive(self._equipped_unit) and self._equipped_unit:base() and not self._equipped_unit:base()[Idstring("saints:init"):key()] then
		self._equipped_unit:base()[Idstring("saints:init"):key()] = true
		self._equipped_unit:base().__old_reload_speed_multiplier = self._equipped_unit:base().__old_reload_speed_multiplier or self._equipped_unit:base().reload_speed_multiplier
		self._equipped_unit:base().reload_speed_multiplier = function(them, ...)
			return them:__old_reload_speed_multiplier(...) * 1.5
		end
	end
end)