_G.Rage_Special = _G.Rage_Special or {}
Rage_Special._Rage_Special_HUD_RUN_Init = false
Rage_Special._Rage_Special_HUD_RUN_Dalay = 0
if HUDHeistTimer then
	local _Rage_Special_HUDHeistTimer_set_time = HUDHeistTimer.set_time
	function HUDHeistTimer:set_time(...)
		_Rage_Special_HUDHeistTimer_set_time(self, ...)
		if managers.hud.Rage_Special_HUD and Rage_Special and self._last_time > 5 then
			if not Rage_Special._Rage_Special_HUD_RUN_Init then
				Rage_Special._Rage_Special_HUD_RUN_Init = true
				managers.hud.Rage_Special_HUD:SetData()
				managers.hud.Rage_Special_HUD:SetVisible(true)
			end
			if self._last_time > Rage_Special._Rage_Special_HUD_RUN_Dalay then
				Rage_Special._Rage_Special_HUD_RUN_Dalay = self._last_time + 0.5
				managers.hud.Rage_Special_HUD:Update(self._last_time)
			end
		end
	end
end