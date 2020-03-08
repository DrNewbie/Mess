Hooks:PostHook(PlayerDamage, "update", "F_"..Idstring("PostHook:PlayerDamage:update:Low Health Shake"):key(), function(self, _, _, __dt)
	if not self.__ext_camera then
		self.__ext_camera = self._unit:camera()
		self.__low_hp_shake_dt = nil
	else
		if not self.__low_hp_shake_dt and self:health_ratio() + 0.0011 < self._max_health_reduction then
			self.__low_hp_shake_dt = 0.7 + math.random()/10
			self.__ext_camera:play_shaker("player_taser_shock", 
				math.clamp(
					1 - (self:health_ratio()/self._max_health_reduction), 0.001, 0.995
				)*3.5, 10)
		end
		if self.__low_hp_shake_dt then
			self.__low_hp_shake_dt = self.__low_hp_shake_dt - __dt
			if self.__low_hp_shake_dt < 0 then
				self.__low_hp_shake_dt = nil
			end
		end
	end
end)
