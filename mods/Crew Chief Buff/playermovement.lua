Hooks:PostHook(PlayerMovement, "init", "F_"..Idstring("ccb_player_long_dis_revive_range_mul"):key(), function(self)
	if managers.player:has_category_upgrade("player", "ccb_long_dis_revive_range_mul") and self._rally_skill_data and self._rally_skill_data.range_sq then
		self._rally_skill_data.range_sq = self._rally_skill_data.range_sq * 1.25 * 1.25
	end
end)