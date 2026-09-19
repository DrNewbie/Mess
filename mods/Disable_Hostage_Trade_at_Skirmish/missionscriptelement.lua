core:import("CoreMissionScriptElement")
core:import("CoreClass")

if not MissionScriptElement then return end

Alt_Ele_MissionScript_on_executed = Alt_Ele_MissionScript_on_executed or MissionScriptElement.on_executed
function MissionScriptElement:on_executed(...)
	if managers and managers.skirmish and managers.skirmish:is_skirmish() then
		if self._editor_name == "hostage_interaction_link" then
			return
		end
	end
	Alt_Ele_MissionScript_on_executed(self, ...)
end