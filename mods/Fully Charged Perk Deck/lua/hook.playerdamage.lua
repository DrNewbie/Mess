Hooks:PostHook(PlayerDamage, "init", "SetFullyChargedInvulnerableInit", function(self)
	self._fully_charged_invulnerable = nil
	self._fully_charged_invulnerable_t = 0
	self._fully_charged_time2damage_t = 0
end)

Hooks:PostHook(PlayerDamage, "update", "SetFullyChargedHitInit", function(self, unit, t)
	if self._fully_charged_invulnerable then
		if self._fully_charged_invulnerable_t <= 0 then
			self._fully_charged_invulnerable_t = t + managers.player:upgrade_value("player", "passive_fully_charged_invulnerable", 0)
		elseif self._fully_charged_invulnerable_t > t then
		
		else
			self:set_fully_charged_invulnerable(false)
		end
	end
end)

function PlayerDamage:set_fully_charged_invulnerable(state)
	self._fully_charged_invulnerable_t = 0
	self._fully_charged_invulnerable = state
	self:set_invulnerable(state)
end