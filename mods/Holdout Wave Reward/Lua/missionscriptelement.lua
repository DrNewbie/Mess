core:import("CoreMissionScriptElement")
core:import("CoreClass")

if not MissionScriptElement then return end

Hooks:PostHook(MissionScriptElement, "on_executed", "F_"..Idstring("PostHook:MissionScriptElement:on_executed:Holdout Wave Reward"):key(), function(self)
	if managers and managers.skirmish and managers.skirmish:is_skirmish() then
		if self._editor_name == "hostage_interaction_link" then
			managers.skirmish:Spawn_Holdout_Wave_Reward()
		end
	end
end)