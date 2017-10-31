if Network:is_client() then
	return
end

_G.SurvivorModeBase = _G.SurvivorModeBase or {}

local _f_start_single_player_job = MenuCallbackHandler.start_single_player_job
local _f_start_job = MenuCallbackHandler.start_job

function MenuCallbackHandler:start_single_player_job(...)
	SurvivorModeBase:Create_Empty_One()
	return _f_start_single_player_job(self, ...)
end

function MenuCallbackHandler:start_job(...)
	SurvivorModeBase:Create_Empty_One()
	return _f_start_job(self, ...)
end