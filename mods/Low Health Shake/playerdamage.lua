Hooks:PostHook(PlayerDamage, "update", "F_"..Idstring("PostHook:PlayerDamage:update:Low Health Shake"):key(), function(self)
	if not self.__ext_camera then
		self.__ext_camera = self._unit:camera()
	else
		if self:health_ratio() < 0.3 and managers.player:upgrade_value("player", "max_health_reduction", 1) then
			self.__ext_camera:play_shaker("player_taser_shock", math.clamp((0.3 - self:health_ratio()), 0.001, 0.295)*3.5, 10)
		elseif self:health_ratio() < 1 and not managers.player:upgrade_value("player", "max_health_reduction", 1) then
			self.__ext_camera:play_shaker("player_taser_shock", math.clamp((1 - self:health_ratio()), 0.001, 0.995)*3.5, 10)
		end
	end
end)
