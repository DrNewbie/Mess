core:import("CoreMissionScriptElement")
core:import("CoreClass")

MissionScriptElement = MissionScriptElement or class(CoreMissionScriptElement.MissionScriptElement)

if not MissionScriptElement then return end

if Network and Network:is_client() then return end

Hooks:PostHook(MissionScriptElement, "init", "EnableAllSecurityCameraInit", function(self, mission_script, data)
	self._ele_class_name = data.class
end)