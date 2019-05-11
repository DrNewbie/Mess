core:module("CoreElementLogicChance")
core:import("CoreMissionScriptElement")
ElementLogicChance = ElementLogicChance or class(CoreMissionScriptElement.MissionScriptElement)

if Global.level_data and Global.level_data.level_id and Global.level_data.level_id == "kenaz" then
	Hooks:PreHook(ElementLogicChance, "on_executed", "fc53214492d3d608", function(self)
		if self._editor_name == "1_chance" and (Global.level_data.level_id == "kenaz" or Global.level_data.level_id == "chill") then
			self._chance = 999
		end
	end)
end