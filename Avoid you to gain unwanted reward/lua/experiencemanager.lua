_G.EXPRewardLater = _G.EXPRewardLater or {}

local EXPRewardLater_mission_xp = ExperienceManager.mission_xp

function ExperienceManager:mission_xp(...)
	local _XP = EXPRewardLater_mission_xp(self, ...)
	if EXPRewardLater.settings.SaveThisTime == 1 then
		EXPRewardLater.settings.XP_Saved = _XP
		_XP = 0
	else
		_XP = _XP + EXPRewardLater.settings.XP_Saved
		EXPRewardLater.settings.XP_Saved = 0
	end
	EXPRewardLater:Save()
	return _XP
end