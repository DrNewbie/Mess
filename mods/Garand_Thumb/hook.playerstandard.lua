local ThisModPath = tostring(ModPath)
local __NameIds = function(__data)
	return "GT_"..Idstring(ThisModPath..string.format("%q", __data)):key()
end
local _forced_stop = __NameIds("_forced_stop")
local _forced_stop_dt = __NameIds("_forced_stop_dt")
local reload_expire_t_req = __NameIds("reload_expire_t_req")
local __reload_anim_recover = __NameIds("__reload_anim_recover")
local not_working = __NameIds("not_working")

Hooks:PostHook(PlayerStandard, "_update_reload_timers", "F_"..Idstring("PostHook::Garand Thumb"):key(), function(self, t, dt, input, ...)
	if self._camera_unit and self._ext_damage and self._equipped_unit then
		local __weapon_id = alive(self._equipped_unit) and self._equipped_unit:base() and self._equipped_unit:base():get_name_id()
		if __weapon_id then
			if __weapon_id ~= "ching" then
				self[_forced_stop] = nil
			else
				if self:_is_reloading() then
					if not self[_forced_stop] then
						self[_forced_stop] = true
						if math.random() >= 0.66 then
							self[not_working] = true
						else
							self[not_working] = nil
						end
						self[_forced_stop_dt] = t + 0.15
						if type(self._state_data.reload_expire_t) == "number" then
							self._state_data[reload_expire_t_req] = self._state_data.reload_expire_t - t
						end
					else
						if self[_forced_stop] and type(self[_forced_stop_dt]) == "number" and self[_forced_stop_dt] < t  then
							local current_state_name = self._camera_unit:anim_state_machine():segment_state(self:get_animation("base"))
							local segment_real_time = self._unit:anim_state_machine():segment_real_time(Idstring("base"))
							if type(self._state_data.reload_expire_t) == "number" and type(self._state_data[reload_expire_t_req]) == "number" then
								local t_rate = math.abs(t - self._state_data.reload_expire_t) / self._state_data[reload_expire_t_req]
								if t_rate >= 0.15 and t_rate <= 0.16 then
									self[__reload_anim_recover] = self._state_data.reload_expire_t + 1.5
									if not self[not_working] then
										self._camera_unit:anim_state_machine():set_speed(current_state_name, 0)
										self._equipped_unit:base():tweak_data_anim_stop("reload_enter")
										self._equipped_unit:base():tweak_data_anim_stop("reload")
										self._equipped_unit:base():tweak_data_anim_stop("reload_not_empty")
										self._equipped_unit:base():tweak_data_anim_stop("reload_exit")
										self._ext_camera:play_shaker("player_taser_shock", 5, 3)
										self._ext_damage:damage_simple({
											variant = "delayed_tick",
											damage = self._ext_damage:get_real_armor()
										})
										self._ext_damage:damage_simple({
											variant = "delayed_tick",
											damage = self._ext_damage:get_real_health() * 0.1 + 1
										})
									end
								end
							end
						end
					end
				else
					if self[_forced_stop] and type(self[__reload_anim_recover]) == "number" and self[__reload_anim_recover] < t then
						self[_forced_stop] = nil
						self[_forced_stop_dt] = 0
						self[__reload_anim_recover] = nil
						self[not_working] = nil
						local current_state_name = self._camera_unit:anim_state_machine():segment_state(self:get_animation("base"))
						self._camera_unit:anim_state_machine():set_speed(current_state_name, 1)
					end
				end
			end
		end
	end
end)