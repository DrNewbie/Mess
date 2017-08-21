_G.UselessHUD = _G.UselessHUD or {}
UselessHUD.Stock_RUN = false
UselessHUD.Weather_RUN = false
if HUDHeistTimer then
	local _f_HUDHeistTimer_set_time = HUDHeistTimer.set_time
	function HUDHeistTimer:set_time(...)
		_f_HUDHeistTimer_set_time(self, ...)
		local _last = math.floor(self._last_time)
		if UselessHUD and _last > 5 then
			if managers.hud._uselesshud_stock and not UselessHUD.Stock_RUN then
				UselessHUD.Stock_RUN = true
				managers.hud._uselesshud_stock:GetData()
			end
			if not UselessHUD.Weather_RUN and managers.hud._uselesshud_weather then
				UselessHUD.Weather_RUN = true
				managers.hud._uselesshud_weather:GetData()
			end
		end
	end
end