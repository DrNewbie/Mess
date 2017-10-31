if Network:is_client() then
	return
end

_G.SurvivorModeBase = _G.SurvivorModeBase or {}

local _missino_init_orig = MissionManager.init
function MissionManager:init(...)
	_missino_init_orig(self, ...)
	if Network:is_client() then
		return
	end
	if Global.game_settings and (Global.game_settings.level_id == "arm_cro" or Global.game_settings.level_id == "escape_park") and SurvivorModeBase then
		SurvivorModeBase.Enable = true
		SurvivorModeBase.isDay1 = Global.game_settings.level_id == "arm_cro"
		SurvivorModeBase.Timer_Enable = false
	else
		SurvivorModeBase.Enable = false
	end
end