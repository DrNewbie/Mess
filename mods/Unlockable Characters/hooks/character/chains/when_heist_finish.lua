require("lib/states/GameState")

MissionEndState = MissionEndState or class(GameState)
MissionEndState.GUI_ENDSCREEN = Idstring("guis/victoryscreen/stage_endscreen")

local UnlockableCharactersSys = _G.UnlockableCharactersSys

if UnlockableCharactersSys._hooks.character_chains_when_heist_finish then
	return
else
	UnlockableCharactersSys._hooks.character_chains_when_heist_finish = true
end

Hooks:PostHook(MissionEndState, "at_enter", UnlockableCharactersSys.__Name("chains heist end"), function(self, ...)
	if self._success then
		DelayedCalls:Add(UnlockableCharactersSys.__Name("delay chains heist end"), 1, function()
			pcall(function()
				local funcs = UnlockableCharactersSys._funcs
				local get_level = funcs.GetThisLevelFinish
				if not funcs.IsThisCharacterUnLocked("chains") then
					if get_level("short1_stage1") >= 3 and 
						get_level("short1_stage2") >= 3 and 
						get_level("short2_stage1") >= 3 and 
						get_level("short2_stage2b") >= 3 then
						funcs.UnLockedThisCharacter("chains")
					end
				else
					funcs.LockedThisCharacter("chains")
				end
				return
			end)
		end)
	end
end)