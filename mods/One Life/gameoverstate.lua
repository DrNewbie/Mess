Hooks:PreHook(GameOverState, "at_enter", "PreHook_GameOverState_at_enter", function()
	Global.OneLifeGoodBye = true
	DelayedCalls:Add('OneLifeGoodBye_RunSet', 0.25, function()
		if Global.game_settings.single_player then
			MenuCallbackHandler:_dialog_end_game_yes()
		else
			setup:load_start_menu()
		end
	end)
end)