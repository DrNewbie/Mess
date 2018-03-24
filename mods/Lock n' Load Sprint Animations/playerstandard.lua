Hooks:PostHook(PlayerStandard, "set_running", "RunAndShootAnim_set_running", function(self)
	if self._ext_camera and self.RUN_AND_RELOAD and self._rar_running and not self._running then
		self._rar_running = nil
		self._rar_hold_back = nil
		self._rar_hold_back_t = nil
		self._ext_camera:play_redirect(self:get_animation("stop_running"), 1)
	end
end)

Hooks:PostHook(PlayerStandard, "_start_action_running", "RunAndShootAnim_start_action_running", function(self)
	if self._ext_camera and self.RUN_AND_RELOAD and self._running then
		self._rar_running = true
		self._ext_camera:play_redirect(self:get_animation("start_running"))
	end
end)

Hooks:PostHook(PlayerStandard, "_check_action_run", "RunAndShootAnim_check_action_run", function(self, t)
	if self._ext_camera and self.RUN_AND_RELOAD and self._running and self._rar_running then
		local is_bool = (self:_is_reloading() or self._shooting) and true or false
		if is_bool then
			if not self._rar_hold_back then
				self._rar_hold_back = true
			end
			self._rar_hold_back_t = t + 1
		else
			if self._rar_hold_back then
				if not self._rar_hold_back_t or t > self._rar_hold_back_t then
					self._rar_hold_back = nil
					self._rar_hold_back_t = nil
					self._ext_camera:play_redirect(self:get_animation("start_running"))
				end
			end			
		end
	end
end)