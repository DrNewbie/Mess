Hooks:PostHook(PlayerManager, "on_killshot", "GunGunEvent_KillCops", function(self)
	local PlyStandard = self:player_unit() and self:player_unit():movement() and self:player_unit():movement()._states.standard or nil
	if PlyStandard and PlyStandard.AskGunGunRun then
		PlyStandard:AskGunGunRun()
	end
end)