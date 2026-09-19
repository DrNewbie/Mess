require("lib/states/GameState")

MissionEndState = MissionEndState or class(GameState)
MissionEndState.GUI_ENDSCREEN = Idstring("guis/victoryscreen/stage_endscreen")

local UnlockableCharactersSys = _G.UnlockableCharactersSys

if UnlockableCharactersSys._hooks.when_heist_finish then
	return
else
	UnlockableCharactersSys._hooks.when_heist_finish = true
end

Hooks:PostHook(MissionEndState, "at_enter", UnlockableCharactersSys.__Name("heist end"), function(self, ...)
	if self._success then
		local __current_level_id = tostring(managers.job:current_level_id())
		UnlockableCharactersSys._funcs.AddThisLevelFinish(__current_level_id, 1)
	end
end)