_G.UselessHUD = _G.UselessHUD or {}
if HUDHeistTimer then
	local _f_HUDHeistTimer_set_time = HUDHeistTimer.set_time
	function HUDHeistTimer:set_time(...)
		_f_HUDHeistTimer_set_time(self, ...)
		if UselessHUD and self._last_time > 5 then
			if not UselessHUD.Weather_RUN then
				UselessHUD.Weather_RUN = true
				managers.hud._uselesshud_weather:GetData()
			end
		end
	end
end