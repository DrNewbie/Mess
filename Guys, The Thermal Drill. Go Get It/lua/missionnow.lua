local _missino_init_orig = MissionManager.init
function MissionManager:init(...)
	_missino_init_orig(self, ...)
	if not PackageManager:loaded("levels/narratives/h_firestarter/stage_3/world_sounds") then
		PackageManager:load("levels/narratives/h_firestarter/stage_3/world_sounds")
	end
end