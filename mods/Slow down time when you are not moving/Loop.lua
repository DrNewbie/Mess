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
		self._moving then
		if PAUSE_TOGGLE_PLY == true then
			PAUSE_TOGGLE_PLY = false
			--Application:set_pause(false)
			for _, v in pairs({"player", "game", "game_animation"}) do
				TimerManager:timer(Idstring(v)):set_multiplier(1)
			end
		end
		return
	else
		if PAUSE_TOGGLE_PLY ~= true then
			PAUSE_TOGGLE_PLY = true
			--Application:set_pause(true)
			for _, v in pairs({"player", "game", "game_animation"}) do
				TimerManager:timer(Idstring(v)):set_multiplier(0.25)
			end
		end
	end
end)