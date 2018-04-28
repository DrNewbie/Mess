core:module("CoreElementRandom")
core:import("CoreMissionScriptElement")
core:import("CoreTable")

ElementRandom = ElementRandom or class(CoreMissionScriptElement.MissionScriptElement)

if not ElementRandom or not Global.game_settings or not Global.game_settings.level_id or not Global.game_settings.level_id == "election_day_1" then
	return
end

_G.CodesHelper = _G.CodesHelper or {}

local CodesHelper = _G.CodesHelper

Hooks:PostHook(ElementRandom, "on_executed", "CodesHelper_GetCodesAns", function(self)
	if Global.game_settings.level_id == "election_day_1" and self._id == 100631 then
		local Ans = self._values.on_executed[1]
		if Ans and Ans.id then
			local Ans_id = tonumber(tostring(Ans.id))
			if Ans_id == 100633 then
				CodesHelper:Set_Codes({Truck = Vector3(878, -3360, 50)})
			elseif Ans_id == 100634 then
				CodesHelper:Set_Codes({Truck = Vector3(828, -2222, 50)})
			elseif Ans_id == 100635 then
				CodesHelper:Set_Codes({Truck = Vector3(848, -1084, 50)})
			elseif Ans_id == 100636 then
				CodesHelper:Set_Codes({Truck = Vector3(150, -3900, 50)})
			elseif Ans_id == 100637 then
				CodesHelper:Set_Codes({Truck = Vector3(150, -2775, 50)})
			elseif Ans_id == 100639 then
				CodesHelper:Set_Codes({Truck = Vector3(150, -1628, 50)})
			end
		end
	end
end)