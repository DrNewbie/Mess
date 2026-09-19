core:module("CoreElementCounter")
core:import("CoreMissionScriptElement")
core:import("CoreClass")

ElementCounter = ElementCounter or class(CoreMissionScriptElement.MissionScriptElement)

ElementCounterOperator = ElementCounterOperator or class(CoreMissionScriptElement.MissionScriptElement)

if not Global.game_settings or (Global.game_settings.level_id ~= "watchdogs_2" and Global.game_settings.level_id ~= "watchdogs_2_day") then
	return
end

Hooks:PostHook(ElementCounterOperator, "on_executed", "F_"..Idstring("PostHook:ElementCounterOperator:on_executed:Reduce Boat Load (Watchdogs - Day 2)"):key(), function(self)
	if not Global.game_settings or (Global.game_settings.level_id ~= "watchdogs_2" and Global.game_settings.level_id ~= "watchdogs_2_day") then
	
	else
		if self._id == 100717 or self._id == 100715 or self._id == 100716 then
			for _, id in ipairs(self._values.elements) do
				local element = self:get_mission_element(id)
				if element then
					element:counter_operation_set(4)
				end
			end
		end
	end
end)