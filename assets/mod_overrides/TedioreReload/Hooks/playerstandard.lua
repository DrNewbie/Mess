if (Net and Net:IsHost()) or (Global.game_settings and Global.game_settings.single_player) then
	local HookThatStandardPlyReloadEnter = PlayerStandard._start_action_reload_enter

	function PlayerStandard:_start_action_reload_enter(t, ...)
		if self._equipped_unit and self._equipped_unit:base():can_reload() then
			local wep_unit = self._equipped_unit
			local wep_base = wep_unit:base()
			if wep_base._blueprint and table.contains(wep_base._blueprint, "wpn_fps_throwandreload") then
				local speed_multiplier = wep_base:reload_speed_multiplier() or 1
				local tweak_data = wep_base:weapon_tweak_data()
				self._state_data.reload_expire_t = t + (tweak_data.timers.reload_empty or wep_base:reload_expire_t() or 2.6) / speed_multiplier
				managers.player:player_unit():equipment():throw_and_reload_set(self, wep_unit)
				self._ext_camera:play_redirect(Idstring("throw_grenade"), 1)
				return
			end
		end
		return HookThatStandardPlyReloadEnter(self, t, ...)
	end
end