Hooks:PostHook(PlayerDamage, "update", "F_"..Idstring("PostHook:PlayerDamage:update:Detection No Down"):key(), function(self)
	if self._unit:movement() then
		local susp_ratio = self._unit:movement()._suspicion_ratio
		if type(susp_ratio) ~= "number" then
			susp_ratio = self._unit:movement().__suspicion_ratio_hold
			if susp_ratio > 0 then
				local offset = self._unit:base():suspicion_settings().hud_offset
				susp_ratio = susp_ratio * (1 - offset) + offset
				managers.hud:set_suspicion(susp_ratio)
			end
		end
	end
end)