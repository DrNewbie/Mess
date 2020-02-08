local rtr_original_PlayerStandard_startactionrunning = PlayerStandard._start_action_running
function PlayerStandard:_start_action_running(t)
	local not_near_the_end = true
	if self.rtr_start_time and self._state_data.reload_expire_t then
		not_near_the_end = ((t - self.rtr_start_time) / (self._state_data.reload_expire_t - self.rtr_start_time)) < ReloadThenRun.settings.block_after_pct
	end
	
	if self.RUN_AND_RELOAD or not self:_is_reloading() or not_near_the_end or self._equipped_unit:base():reload_interuptable() then
		rtr_original_PlayerStandard_startactionrunning(self, t)
	end
end

local rtr_original_PlayerStandard_updatereloadtimers = PlayerStandard._update_reload_timers
function PlayerStandard:_update_reload_timers(t, dt, input)
	self.rtr_start_time = self._state_data.reload_expire_t and (self.rtr_start_time or t) or nil
	rtr_original_PlayerStandard_updatereloadtimers(self, t, dt, input)
end

