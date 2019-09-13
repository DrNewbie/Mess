Hooks:PostHook(PlayerStandard , "_check_action_reload", "ActiveReloadPostPlyStdActive", function(self, t, input)
	if input.btn_reload_press and self._state_data.show_active_reload and self:_is_reloading() then
		if self._state_data._active_reload_offset and self._state_data._active_reload_offset ~= t then
			if self._state_data.active_reload_rate and not self._state_data.active_reload_press then
				self._state_data.active_reload_press = true
				if self._state_data.active_reload_rate == 50 then
					self._equipped_unit:base():tweak_data_anim_stop("reload_enter")
					self._equipped_unit:base():tweak_data_anim_stop("reload")
					self._equipped_unit:base():tweak_data_anim_stop("reload_not_empty")
					self._equipped_unit:base():tweak_data_anim_stop("reload_exit")
					self._equipped_unit:base():on_reload()
					managers.hud:set_ammo_amount(self._equipped_unit:base():selection_index(), self._equipped_unit:base():ammo_info())
					self:_interupt_action_reload(t)
				end
			end
		end
	end	
end)

Hooks:PreHook(PlayerStandard , "_start_action_reload", "ActiveReloadPrePlyStdStart", function(self, t)
	if self._equipped_unit and not self._equipped_unit:base():clip_full() then
		self._state_data.show_active_reload = true
	end	
end)

Hooks:PostHook(PlayerStandard , "_start_action_reload", "ActiveReloadPostPlyStdStart", function(self, t)
	if self._state_data.show_active_reload then
		self._state_data._active_reload_offset = t
		managers.hud:set_active_reload_visible(true)
		managers.hud:set_active_reload(0, self._state_data.reload_expire_t or 0, "Active Reload")
	end	
end)

Hooks:PostHook(PlayerStandard , "_update_reload_timers", "ActiveReloadPostPlyStdUpdate", function(self, t)
	if not self._state_data.reload_expire_t and self._state_data.show_active_reload then
		self._state_data.show_active_reload = nil
		self._state_data.active_reload_rate = nil
		self._state_data.active_reload_press = nil
		managers.hud:set_active_reload_visible(false)
	elseif self._state_data.show_active_reload then
		local curr = t and t - self._state_data._active_reload_offset or 0
		local totl = self._state_data.reload_expire_t and self._state_data.reload_expire_t - self._state_data._active_reload_offset or 0
		self._state_data.active_reload_rate = math.round((curr / totl) * 100)
		managers.hud:set_active_reload(curr, totl, "Active Reload")
	end	
end)