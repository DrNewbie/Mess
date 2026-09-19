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
				self._ask_loop_fire_to_all_dt = 1 + dt
				local weapon_unit = self:player_unit():inventory():equipped_unit()
				local weapon_id = nil
				if weapon_unit then
					local base_ext = weapon_unit:base()
					weapon_id = base_ext and base_ext.get_name_id and base_ext:get_name_id()
				end
				local __all_enemies = managers.enemy:all_enemies()
				for _, data in pairs(__all_enemies) do
					if data.unit and alive(data.unit) then
						local fire_data = {
							unit = data.unit,
							dot_data = tweak_data.dot:get_dot_data("ammo_flamethrower_mk2_rare"),
							weapon_id = weapon_id,
							weapon_unit = weapon_unit,
							attacker_unit = self:player_unit()
						}
						managers.fire:add_doted_enemy(fire_data)
					end
				end
				if TimerManager:game():time() >= self._ask_loop_fire_to_all_times then
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