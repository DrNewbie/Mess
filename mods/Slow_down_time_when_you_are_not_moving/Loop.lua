local PAUSE_TOGGLE_PLY = nil
Hooks:PostHook(PlayerStandard, "update", "PlyS"..Idstring("SUPERHOTUPDATE"):key(), function(self)
	if not self._unit then
		return
	end
	if self:in_air() or 
		self:is_deploying() or 
		self:_on_zipline() or 
		self:_is_throwing_projectile() or 
		self:_is_throwing_grenade() or 
		self:_interacting() or 
		self:_is_meleeing() or 
		self:is_equipping() or 
		self:is_switching_stances() or 
		self:_is_cash_inspecting() or 
		self:shooting() or 
		self:running() or 
		self:_is_charging_weapon() or 
		self:_is_reloading() or 
		self:_changing_weapon() or 
		self:chk_action_forbidden("interact") or 
		self._moving then
		if PAUSE_TOGGLE_PLY == true then
			PAUSE_TOGGLE_PLY = false
			TimerManager:timer(Idstring("player")):set_multiplier(1)
			TimerManager:timer(Idstring("game")):set_multiplier(1)
			TimerManager:timer(Idstring("game_animation")):set_multiplier(1)
		end
	else
		if PAUSE_TOGGLE_PLY ~= true then
			PAUSE_TOGGLE_PLY = true
			TimerManager:timer(Idstring("player")):set_multiplier(0.25)
			TimerManager:timer(Idstring("game")):set_multiplier(0.25)
			TimerManager:timer(Idstring("game_animation")):set_multiplier(0.25)
		end
	end
end)