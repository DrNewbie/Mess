Hooks:PostHook(MissionManager, "init", "BigLobbyModifyAddMoreBots", function()
	if BigLobbyGlobals.allow_more_bots_settings then
		CriminalsManager.MAX_NR_TEAM_AI = BigLobbyGlobals:num_bot_slots()
	end
	CriminalsManager.MAX_NR_CRIMINALS = BigLobbyGlobals:num_player_slots()
end)