local ThisModPath = tostring(ModPath)
local ThisModIds = Idstring(ThisModPath):key()

local __Name = function(__id)
	return "K_"..Idstring(tostring(__id).."::"..ThisModIds):key()
end

local function __Is_Not_Init(__ClassFunc, __RequiredScript)
	if __ClassFunc and not _G[__Name(__RequiredScript)] then
		_G[__Name(__RequiredScript)] = true
		return true
	end
	return false
end

if __Is_Not_Init(GameOverState, RequiredScript) then
	require("lib/states/GameState")
	Hooks:PostHook(GameOverState, "at_enter", __Name(202), function(...)
		pcall(function()
			if HudBattleAnnouncersNotification then
				HudBattleAnnouncersNotification.queue_by_heist({
					is_heist_end_state = true,
					is_gameover_state = true,
					job_id = managers.job:current_job_id(),
					level_id = managers.job:current_level_id()
				})
			end
		end)
	end)
end

if __Is_Not_Init(VictoryState, RequiredScript) then
	require("lib/states/GameState")
	VictoryState = VictoryState or class(MissionEndState)
	Hooks:PostHook(VictoryState, "at_enter", __Name(203), function(...)
		pcall(function()
			if HudBattleAnnouncersNotification then
				HudBattleAnnouncersNotification.queue_by_heist({
					is_heist_end_state = true,
					is_victory_state = true,
					job_id = managers.job:current_job_id(),
					level_id = managers.job:current_level_id()
				})
			end
		end)
	end)
end