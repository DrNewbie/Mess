core:module("CoreElementLogicChance")
core:import("CoreMissionScriptElement")
ElementLogicChance = ElementLogicChance or class(CoreMissionScriptElement.MissionScriptElement)

if Global.level_data and Global.level_data.level_id and (Global.level_data.level_id == "kenaz" or Global.level_data.level_id == "skm_cas") then
	Hooks:PreHook(ElementLogicChance, "on_executed", "F_"..Idstring("PreHook:ElementLogicChance:on_executed:Slot Machine Cheat"):key(), function(self)
		if self._editor_name == "1_chance" and (Global.level_data.level_id == "kenaz" or Global.level_data.level_id == "skm_cas") then
			self._chance = 999
		end
	end)
end