core:module("CoreElementRandom")
core:import("CoreMissionScriptElement")
core:import("CoreTable")

ElementRandom = ElementRandom or class(CoreMissionScriptElement.MissionScriptElement)

if not ElementRandom or not Global.game_settings or not Global.game_settings.level_id or not Global.game_settings.level_id == "tag" then
	return
end

_G.CodesHelper = _G.CodesHelper or {}

local CodesHelper = _G.CodesHelper

Hooks:PostHook(ElementRandom, "on_executed", "CodesHelper_GetCodesAns", function(self)
	if Global.game_settings.level_id == "tag" and self._id == 100829 then
		local Ans = self._values.on_executed[1]
		if Ans and Ans.id then
			local Ans_id = tonumber(tostring(Ans.id))
			if Ans_id == 102039 then
				CodesHelper:Set_Codes({Stuff = 1776})
			elseif Ans_id == 100835 then
				CodesHelper:Set_Codes({Stuff = 2015})
			elseif Ans_id == 100834 then
				CodesHelper:Set_Codes({Stuff = 1234})
			elseif Ans_id == 100830 then
				CodesHelper:Set_Codes({Stuff = 1212})
			end
		end
	end
end)