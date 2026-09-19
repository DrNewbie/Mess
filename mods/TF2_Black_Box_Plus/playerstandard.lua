Hooks:PostHook(PlayerStandard, "_start_action_equip", "F_"..Idstring("PlayerStandard:_start_action_equip:wpn_fps_black_box_body"):key(), function(self)
	if self._equipped_unit and self._equipped_unit:base() and self._equipped_unit:base()._is_black_box and not self._equipped_unit:base()._is_black_box_check then
		local weapon = self._equipped_unit:base()
		weapon._is_black_box_check = true
		weapon._projectile_type = 'west_arrow_exp'
		weapon:weapon_tweak_data().projectile_type = weapon._projectile_type
		if weapon._ammo_data and weapon._ammo_data.launcher_grenade then
			weapon._ammo_data.launcher_grenade = weapon._projectile_type
		end
		weapon:on_reload()
	end
end)