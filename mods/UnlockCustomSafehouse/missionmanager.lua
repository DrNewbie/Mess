Hooks:PostHook(MissionManager, "init", "UnlockCustomSafehouse:MissionManager:init", function(self)
	Global.mission_manager.has_played_tutorial = true
end)