_G.EngineHelper = _G.EngineHelper or {}

if not Global.game_settings or Global.game_settings.level_id ~= "welcome_to_the_jungle_2" then
	return
end

Hooks:PostHook(DialogManager, "queue_dialog", "EngineHelper_Attach", function(self, id, ...)
	if not Global.game_settings or Global.game_settings.level_id ~= "welcome_to_the_jungle_2" or not EngineHelper then

	else
		if id == "pln_bo2_33" then
			EngineHelper:_set_waypoint()
		end
		if id == "pln_bo2_35" then
			EngineHelper:_remove_waypoint('CorrectOne')
		end	
	end
end)