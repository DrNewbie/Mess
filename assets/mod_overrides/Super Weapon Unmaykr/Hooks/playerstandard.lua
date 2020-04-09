Hooks:PostHook(PlayerStandard, "update", "F_"..Idstring("PostHook:PlayerStandard:update:Super Weapon: Unmaykr"):key(), function(self, t, dt)
	local _wep_base = alive(self._equipped_unit) and self._equipped_unit:base() or nil
	if Utils and _wep_base and _wep_base.__is_wpn_fps_sss_unmaykr and _wep_base.__wpn_fps_sss_unmaykr_bomb then
		for __x_key, __x_data in pairs(_wep_base.__wpn_fps_sss_unmaykr_bomb) do
			if type(__x_data.__dead_t) == "number" then
				if t > __x_data.__dead_t then
					_wep_base.__wpn_fps_sss_unmaykr_bomb[__x_key].__dead_t = nil
				else
					local __mvec1 = __x_data.__to_pos - __x_data.__from_pos
					local __mvec2 = __x_data.__unit:position()
					mvector3.normalize(__mvec1)
					mvector3.add(__mvec2, __mvec1 * 20)
					__x_data.__unit:set_position(__mvec2)
					__x_data.__unit:set_rotation(Rotation(math.random(360), math.random(360), math.random(360)))
					local __units = World:find_units("sphere", __mvec2, 150, self._equipped_unit:base().__wpn_fps_sss_unmaykr_hit_slot, "ignore_unit", {self._equipped_unit, self._unit})
					if __units then
						local __is_hit
						for _, __hit in pairs(__units) do
							if __hit.character_damage and __hit:character_damage() and not __hit:character_damage():dead() and __hit:character_damage().damage_explosion then
								__hit:character_damage():damage_explosion({
									variant = "explosion",
									attacker_unit = self._unit,
									range = 10,
									damage = math.round(__hit:character_damage()._HEALTH_INIT * 0.4) + 1,
									col_ray = {
										position = __mvec2,
										ray = math.UP
									}
								})
								__is_hit = true	
							end
						end
						if __is_hit then
							managers.explosion:play_sound_and_effects(
								__mvec2,
								math.UP,
								1000,
								{
									sound_event = "grenade_explode",
									effect = "effects/payday2/particles/explosions/grenade_explosion",
									camera_shake_max_mul = 4,
									sound_muffle_effect = true,
									feedback_range = 10
								}
							)
							_wep_base.__wpn_fps_sss_unmaykr_bomb[__x_key].__dead_t = nil
						end
					end
				end
			else
				if __x_data.__unit and alive(__x_data.__unit) then
					World:delete_unit(__x_data.__unit)
					_wep_base.__wpn_fps_sss_unmaykr_bomb[__x_key] = nil				
				end
			end
		end
	end
end)