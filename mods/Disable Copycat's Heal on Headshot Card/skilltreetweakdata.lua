Hooks:PostHook(SkillTreeTweakData, "init", "Disable Copycat's Heal on Headshot Card", function(self, ...)
	for __i, __d in pairs(self.specializations[23][3].upgrades) do
		if type(__d) == "string" and __d == "player_headshot_regen_health_bonus_1" then
			self.specializations[23][3].upgrades[__i] = nil
			break
		end
	end
end)