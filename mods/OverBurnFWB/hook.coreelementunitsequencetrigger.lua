core:module("CoreElementUnitSequenceTrigger")
core:import("CoreMissionScriptElement")
core:import("CoreCode")

ElementUnitSequenceTrigger = ElementUnitSequenceTrigger or class(CoreMissionScriptElement.MissionScriptElement)

if Network and Network:is_client() then
	return
end

local OverBurnBlock = nil

Hooks:PreHook(ElementUnitSequenceTrigger, "on_executed", "F_"..Idstring("PreHook:ElementUnitSequenceTrigger:on_executed:OverBurn"):key(), function(self)
	if not Global.game_settings or Global.game_settings.level_id ~= "red2" then
	
	else
		if not OverBurnBlock and self._editor_name == "placed_2nd_thermite" then
			OverBurnBlock = true
			self._values.enabled = false
		end
	end
end)