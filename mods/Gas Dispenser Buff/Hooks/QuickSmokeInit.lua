Hooks:PostHook(PlayerManager, "add_grenade_amount", "F_"..Idstring("PostHook:PlayerManager:add_grenade_amount:Gas Dispenser Buff"):key(), function(self, __var)
	if managers.blackmarket:equipped_grenade() ~= "tag_team" or type(__var) ~= "number" or __var >= 0 then
	
	else
		local base_values = managers.player:upgrade_value("player", "tag_team_base")
		if type(base_values) == "table" and type(base_values.duration) == "number" then
			if self.__QuickSmokeHuskAlt and self.__QuickSmokeHuskAlt._timer then
				self.__QuickSmokeHuskAlt._timer = -1
				self.__QuickSmokeHuskAlt:update(TimerManager:game():time(), 0.1)
				self.__QuickSmokeHuskAlt = nil
			end
			self.__QuickSmokeHuskAlt = SmokeScreenEffectAltAlt:new(self:player_unit():position(), math.UP, base_values.duration * 0.75)
			if self.__QuickSmokeHuskAlt then
				self._smoke_screen_effects = self._smoke_screen_effects or {}
				table.insert(self._smoke_screen_effects, self.__QuickSmokeHuskAlt)
			end
		end
	end
end)

Hooks:PostHook(PlayerManager, "update", "F_"..Idstring("PostHook:PlayerManager:update:Gas Dispenser Buff"):key(), function(self, t, dt)
	if self.__QuickSmokeHuskAlt and self.__QuickSmokeHuskAlt.update then
		if self:player_unit() then
			self.__QuickSmokeHuskAlt._position = self:player_unit():position()
			World:effect_manager():move(self.__QuickSmokeHuskAlt._effect, self:player_unit():position())
		end
		self.__QuickSmokeHuskAlt:update(t, dt)
	end
end)

__old_attempt_tag_team = __old_attempt_tag_team or PlayerManager._attempt_tag_team

function PlayerManager:_attempt_tag_team(...)
	local __ans = __old_attempt_tag_team(self, ...)
	if self:player_unit() and not __ans then
		if self._coroutine_mgr:is_running("tag_team") then
		
		else
			self:add_coroutine("tag_team", PlayerAction.TagTeam, self:player_unit(), self:player_unit())
			return true
		end
	end
	return __ans
end