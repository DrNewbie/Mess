Hooks:PostHook(CopActionShoot, "init", "flamethrower_mk2_crew_action_init", function(self)
	if self._weapon_base._flamethrower_init then
		for i, d in pairs(self._falloff) do
			if self._falloff[i].mode then
				self._falloff[i].mode = {0, 0, 0, 1}
			end
		end
		self._w_usage_tweak.FALLOFF = self._falloff
	end
end)