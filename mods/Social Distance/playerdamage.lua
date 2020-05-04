Hooks:PostHook(PlayerDamage, "update", "F_"..Idstring("PostHook:PlayerDamage:update:Social Distance"):key(), function(self, _, _, dt)
	if self._unit and alive(self._unit) then
		local __units = World:find_units("sphere", self._unit:position(), 600, managers.slot:get_mask("persons"))
		for _, _unit in pairs(__units) do 
			if _unit and alive(_unit) and _unit ~= self._unit then
				self:damage_killzone({
					variant = "killzone",
					damage = 0.1,
					col_ray = {
						ray = math.UP
					}
				})		
				break
			end
		end
	end
end)