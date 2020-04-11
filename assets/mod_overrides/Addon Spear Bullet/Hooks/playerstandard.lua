Hooks:PostHook(PlayerStandard, "update", "F_"..Idstring("PostHook:PlayerStandard:update:Addition Spear Bullet"):key(), function(self, t, dt)
	local _wep_base = alive(self._equipped_unit) and self._equipped_unit:base() or nil
	if Utils and _wep_base and _wep_base.__is_wpn_fps_sss_spear and _wep_base.__wpn_fps_sss_spear_bomb then
		for __x_key, __x_data in pairs(_wep_base.__wpn_fps_sss_spear_bomb) do
			if type(__x_data.__dead_t) == "number" then
				if t > __x_data.__dead_t then
					_wep_base.__wpn_fps_sss_spear_bomb[__x_key].__dead_t = nil
				else
					if __x_data.__unit and alive(__x_data.__unit) then
						local __mvec1 = __x_data.__to_pos - __x_data.__from_pos
						local __mvec2 = __x_data.__unit:position()
						local __last_pos = __x_data.__unit:position()
						local __mrot1 = Rotation()
						mvector3.normalize(__mvec1)
						mvector3.add(__mvec2, __mvec1 * 40)
						__x_data.__unit:set_position(__mvec2)
						mrotation.set_look_at(__mrot1, __mvec1, math.UP)
						__x_data.__unit:set_rotation(__mrot1)
						local __col_ray = World:raycast("ray", __last_pos, __mvec2, "slot_mask", self._equipped_unit:base().__wpn_fps_sss_spear_hit_slot, "ignore_unit", {self._equipped_unit, self._unit})
						if __col_ray and __col_ray.unit then
							local __hit = __col_ray.unit
							if __hit.character_damage and __hit:character_damage() and not __hit:character_damage():dead() and __hit:character_damage().damage_explosion then
								__hit:character_damage():damage_explosion({
									variant = "explosion",
									attacker_unit = self._unit,
									range = 1,
									damage = (tweak_data.projectiles.wpn_prj_jav.damage or 10) + 0.1,
									col_ray = {
										position = __mvec2,
										ray = math.UP
									}
								})
							end
							managers.explosion:play_sound_and_effects(
								__mvec2,
								math.UP,
								1,
								CarryData.POOF_CUSTOM_PARAMS
							)
							_wep_base.__wpn_fps_sss_spear_bomb[__x_key].__dead_t = nil
						end
					end
				end
			else
				if __x_data.__unit and alive(__x_data.__unit) then
					World:delete_unit(__x_data.__unit)
					_wep_base.__wpn_fps_sss_spear_bomb[__x_key] = nil				
				end
			end
		end
	end
end)