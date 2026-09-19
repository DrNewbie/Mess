Hooks:PostHook(TripMineBase, '_sensor', 'F_'..Idstring('_sensor:Trip Mine ECM'):key(), function(self)
	if self._owner and managers.player:player_unit() and managers.player:player_unit() == self._owner and type(self._sensor_units_detected) == "table" and type(managers.enemy:all_enemies()) == "table" then
		local ray = self:_raycast()
		if ray and ray.unit and not tweak_data.character[ray.unit:base()._tweak_table].is_escort then
			if self._sensor_units_detected[ray.unit:key()] and managers.enemy:all_enemies()[ray.unit:key()] and ray.unit:character_damage() and ray.unit:character_damage().damage_explosion then
				ray.unit:character_damage():damage_explosion({
					damage = 0,
					variant = "stun",
					attacker_unit = nil,
					weapon_unit = nil,
					col_ray = {
						position = mvector3.copy(ray.unit:position()),
						ray = math.UP
					}
				})
			end
		end
	end
end)