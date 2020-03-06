Hooks:PostHook(PlayerDamage, "update", "F_"..Idstring("PostHook:PlayerDamage:update:Low Health Shake"):key(), function(self)
	if not self.__ext_camera then
		self.__ext_camera = self._unit:camera()
	else
		if self:health_ratio() then
			self.__ext_camera:play_shaker("player_taser_shock", math.clamp((1 - self:health_ratio()), 0.001, 0.995)*3.5, 10)
		end
	end
end)