Hooks:PostHook(PlayerMovement, "init", "InspireSkillModLowerDistance", function(self)
	if managers.player:has_category_upgrade("player", "long_dis_revive_mod") then
		if type(self._rally_skill_data) == "table" and type(self._rally_skill_data.range_sq) == "number" then
			self._rally_skill_data.range_sq = math.pow(800, 2)
		end
	end
end)