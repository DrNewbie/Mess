function MenuCallbackHandler:play_short_heist(item)
	Global.game_settings.single_player = true
	Global.game_settings.difficulty = "sm_wish"
	Global.game_settings.one_down = true
	Global.game_settings.team_ai = true
	Global.game_settings.team_ai_option = 2
	self:start_single_player_job({
		difficulty = "sm_wish",
		job_id = item and item:parameters().job or "short",
		one_down = true
	})
end