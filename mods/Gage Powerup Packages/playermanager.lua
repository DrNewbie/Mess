function PlayerManager:ask_loop_fire_to_all(t)
	self._ask_loop_fire_to_all_times = t
	self._ask_loop_fire_to_all_dt = nil
end

Hooks:PostHook(PlayerManager, "update", "F_"..Idstring("PostHook:PlayerManager:update:Gage Powerup Packages"):key(), function(self, t, dt)
	if self._ask_loop_fire_to_all_times then
		if self:player_unit() then
			if self._ask_loop_fire_to_all_dt then
				self._ask_loop_fire_to_all_dt = self._ask_loop_fire_to_all_dt - dt
				if self._ask_loop_fire_to_all_dt <= 0 then
					self._ask_loop_fire_to_all_dt = nil
				end
			else
				self._ask_loop_fire_to_all_dt = 2
				self._ask_loop_fire_to_all_times = self._ask_loop_fire_to_all_times - 1
				for _, data in pairs(managers.enemy:all_enemies()) do
					managers.fire:add_doted_enemy(data.unit, TimerManager:game():time(), self:player_unit():inventory():equipped_unit(), 2, 50, self:player_unit(), true)
				end
				if self._ask_loop_fire_to_all_times <= 0 then
					self._ask_loop_fire_to_all_times = nil
					self._ask_loop_fire_to_all_dt = nil				
				end
			end
		else
			self._ask_loop_fire_to_all_times = nil
			self._ask_loop_fire_to_all_dt = nil
		end
	end
end)