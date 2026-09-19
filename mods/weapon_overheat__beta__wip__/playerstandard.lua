Hooks:PostHook(PlayerStandard, "_update_movement", "F_"..Idstring("PostHook:PlayerStandard:_update_movement:__increase_heat:OwO"):key(), function(self, t, dt)
	local wep_base = alive(self._equipped_unit) and self._equipped_unit:base() or nil
	if wep_base and self._shooting then
		if not wep_base.__is_overheat_function_init then
			wep_base.__is_overheat_function_init = true
			wep_base:__weapon_heat_function_init()
		end
		if wep_base.__is_overheat_function then
			wep_base:__increase_heat(10)
		end
	end
end)

Hooks:PostHook(PlayerStandard, "_update_movement", "F_"..Idstring("PostHook:PlayerStandard:_update_movement:__decrease_heat:OwO"):key(), function(self, t, dt)
	local wep_base = alive(self._equipped_unit) and self._equipped_unit:base() or nil
	if wep_base and not self._shooting then
		if wep_base.__is_overheat_function then
			wep_base:__decrease_heat(0.05)
		end
	end
end)