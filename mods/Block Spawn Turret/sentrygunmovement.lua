Hooks:PostHook(SentryGunMovement, "update", 'F_'..Idstring("PostHook:SentryGunMovement:update:MOD THAT REMOVES TURRETS ACTUALLY"):key(), function(self, unit, t, dt)
	if self._unit:base().__prepare_to_boom and not self._unit:character_damage()._dead and self._unit:base().__prepare_to_boom_dt then
		self._unit:base().__prepare_to_boom_dt = self._unit:base().__prepare_to_boom_dt - dt
		if self._unit:base().__prepare_to_boom_dt < 0 then
			self._unit:base().__prepare_to_boom_dt = 3
			local __dmg = self._unit:character_damage()._health or 1
			__dmg = math.max(__dmg * 1.1, 1)
			self._unit:character_damage():_apply_damage(__dmg, true, true, true, nil, "bullet")
		end
	end
end)