core:module("CoreMissionScriptElement")
core:import("CoreXml")
core:import("CoreCode")
core:import("CoreClass")

if not Global.game_settings or Global.game_settings.level_id ~= "branchbank" then
	return
end

if Network:is_client() then
	return
end

_G.NoSenseGate = _G.NoSenseGate or {}

local NoSenseGate = _G.NoSenseGate or {}

local _f_MissionScriptElement_on_executed = MissionScriptElement.on_executed

function MissionScriptElement:on_executed(...)
	local _id = tostring(self._id)
	if (_id == "100718" or _id == "100719") and NoSenseGate and NoSenseGate.Loadad == 1 then
		NoSenseGate:Spawn_the_Gate(_id)
	end
	_f_MissionScriptElement_on_executed(self, ...)
end