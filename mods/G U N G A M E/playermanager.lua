Hooks:PostHook(PlayerManager, "on_killshot", "F_"..Idstring("PostHook:PlayerManager:on_killshot:G U N G A M E"):key(), function(self)
	local PlyStandard = self:player_unit() and self:player_unit():movement() and self:player_unit():movement()._states.standard or nil
	if PlyStandard and PlyStandard.AskGunGunRun then
		PlyStandard:AskGunGunRun()
	end
end)