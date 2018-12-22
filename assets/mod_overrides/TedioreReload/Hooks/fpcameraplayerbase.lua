if (Net and Net:IsHost()) or (Global.game_settings and Global.game_settings.single_player) then
	function FPCameraPlayerBase:check_throw_and_reload()
		if self._parent_unit and alive(self._parent_unit) and self._parent_unit:equipment() and self._parent_unit:equipment()._throw_and_reload and self._parent_unit:equipment()._throw_and_reload.wep_unit then
			return true
		end
		return
	end

	local HookFPCameraPlayerBaseSpawnGrenade = FPCameraPlayerBase.spawn_grenade

	function FPCameraPlayerBase:spawn_grenade(...)
		return self:check_throw_and_reload() or HookFPCameraPlayerBaseSpawnGrenade(self, ...)
	end
end