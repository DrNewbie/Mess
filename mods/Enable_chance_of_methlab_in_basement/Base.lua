core:module("CoreMissionScriptElement")
core:import("CoreXml")
core:import("CoreCode")
core:import("CoreClass")

MissionScriptElement = MissionScriptElement or class()

if not Global.game_settings or (Global.game_settings.level_id ~= "rat" and Global.game_settings.level_id ~= "alex_1") then
	return
end

Hooks:PostHook(MissionScriptElement, "on_script_activated", "F_"..Idstring("PostHook:MissionScriptElement:on_script_activated:Enable chance of methlab in basement"):key(), function(self)
	if not Global.game_settings or (Global.game_settings.level_id ~= "rat" and Global.game_settings.level_id ~= "alex_1") then

	else
		if self._id == 100486 and self._values and not self._values.enabled and not self._values.__re_enabled then
			self._values.__re_enabled = true
			self._values.enabled = true
		end
	end
end)