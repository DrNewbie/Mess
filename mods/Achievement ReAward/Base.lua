local ReAwardBool = {}
local ReAward = AchievmentManager.award
function AchievmentManager:award(id, ...)
	local info = self:get_info(id)
	if info.awarded then
		if managers.hud and not ReAwardBool[id] then
			ReAwardBool[id] = true
			managers.hud:achievement_popup(id)
		end
	end
	return ReAward(self, id, ...)
end