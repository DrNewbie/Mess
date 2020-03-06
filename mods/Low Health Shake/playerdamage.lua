Hooks:PostHook(PlayerDamage, "update", "F_"..Idstring("PostHook:PlayerDamage:update:Low Health Shake"):key(), function(self, unit, t, dt)
	if not self.__ext_camera then
		self.__ext_camera = self._unit:camera()
		if self.__ext_camera then
			self.__hp_shake_number = self:health_ratio()
		end
	else
		if self.__hp_shake_number ~= self:health_ratio() then
			self.__hp_shake_number = self:health_ratio()
		end
		self.__ext_camera:play_shaker("player_taser_shock", math.clamp((1 - self.__hp_shake_number), 0.001, 0.995)*3.5, 10)
	end
end)