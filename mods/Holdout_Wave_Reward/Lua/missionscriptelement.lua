core:import("CoreMissionScriptElement")
core:import("CoreClass")

local ThisModPath = ModPath

local __Name = function(__id)
	return "SS_"..Idstring(tostring(__id).."::"..ThisModPath):key()
end

if not MissionScriptElement then return end

Hooks:PostHook(MissionScriptElement, "on_executed", __Name("on_executed"), function(self)
	if managers and managers.skirmish and managers.skirmish:is_skirmish() then
		if self._editor_name == "hostage_interaction_link" then
			managers.skirmish:Spawn_Holdout_Wave_Reward()
		end
	end
end)