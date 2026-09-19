core:module("CoreMissionScriptElement")
core:import("CoreXml")
core:import("CoreCode")
core:import("CoreClass")

if (not Network or Network:is_server()) and MissionScriptElement and Global.game_settings and Global.game_settings.level_id == "pal" then
	Hooks:PreHook(MissionScriptElement, "on_executed", "StB_Mission_on_executed", function(self)
		if self._editor_name == "start_leave" then
			self._values.enabled = false
		end
	end)
end