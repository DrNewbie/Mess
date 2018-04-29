Hooks:PostHook(PlayerStandard, "set_running", "RunAndShootAnim_set_running", function(self)
	if self._ext_camera and self._rar_running and not self._running then
		self._rar_running = nil
		self._rar_hold_back = nil
		self._rar_hold_back_t = nil
		if self:_is_reloading() or self._shooting then
		
		else
			self._ext_camera:play_redirect(self:get_animation("stop_running"), 1)
		end
	end
end)

Hooks:PostHook(PlayerStandard, "_start_action_running", "RunAndShootAnim_start_action_running", function(self)
	if self._ext_camera and self._running and not self:_is_reloading() and not self._shooting then
		self._rar_running = true
		self._ext_camera:play_redirect(self:get_animation("start_running"))
	end
end)

Hooks:PostHook(PlayerStandard, "_check_action_run", "RunAndShootAnim_check_action_run", function(self, t)
	if self._ext_camera and (self.RUN_AND_RELOAD or self._equipped_unit:base():run_and_shoot_allowed()) then
		local is_bool = (self:_is_reloading() or self._shooting) and true or false
		if self._running then
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
						self._rar_running = true
						self._ext_camera:play_redirect(self:get_animation("start_running"))
					end
				end			
			end
		else
			if self._rar_running and not is_bool and not self:_changing_weapon() and not self:_interacting() and not self:_is_meleeing() and not self._use_item_expire_t and not self:_is_throwing_projectile() and not self:_on_zipline() then
				self._rar_running = nil
				self._rar_hold_back = nil
				self._rar_hold_back_t = nil
				self._ext_camera:play_redirect(self:get_animation("idle"))
			end
		end
	end
end)