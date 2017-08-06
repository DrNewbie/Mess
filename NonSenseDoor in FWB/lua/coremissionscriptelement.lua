core:module("CoreMissionScriptElement")
core:import("CoreXml")
core:import("CoreCode")
core:import("CoreClass")
MissionScriptElement = MissionScriptElement or class()

if not Global.game_settings or Global.game_settings.level_id ~= "red2" then
	return
end

if Network:is_client() then
	return
end

_G.NoSenseDoor = _G.NoSenseDoor or {}

local NoSenseDoor = _G.NoSenseDoor or {}

local _fwb_MissionScriptElement_on_executed = MissionScriptElement.on_executed

function MissionScriptElement:on_executed(...)
	local _id = tostring(self._id)
	if _id == "100329" and NoSenseDoor and NoSenseDoor.Loadad == 1 then
		NoSenseDoor:Spawn_the_Door()
	end
	_fwb_MissionScriptElement_on_executed(self, ...)
end