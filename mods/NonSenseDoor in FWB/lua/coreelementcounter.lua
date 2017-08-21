core:module("CoreElementCounter")
core:import("CoreMissionScriptElement")
core:import("CoreClass")
ElementCounter = ElementCounter or class(CoreMissionScriptElement.MissionScriptElement)

if not Global.game_settings or Global.game_settings.level_id ~= "red2" then
	return
end

if Network:is_client() then
	return
end

_G.NoSenseDoor = _G.NoSenseDoor or {}

local NoSenseDoor = _G.NoSenseDoor or {}

NoSenseDoor._tmp = NoSenseDoor._tmp or {}

NoSenseDoor._tmp["106897"] = NoSenseDoor._tmp["106897"] or 0

local _fwb_ElementCounter_on_executed = ElementCounter.on_executed

function ElementCounter:on_executed(instigator)
	local _id = tostring(self._id)
	local _counter_target = self._values.counter_target or 0
	if _id == "106897" then
		NoSenseDoor._tmp[_id] = NoSenseDoor._tmp[_id] + 1
	end
	if _id == "106897" and NoSenseDoor._tmp["106897"] == 8 then
		local spawn_list = {
			no_shortcut_my_friend_a1 = {no_active = true, pos = Vector3(2990, 440, 0), rot = Rotation()},
			no_shortcut_my_friend_a2 = {no_active = true, pos = Vector3(2960, 440, 0), rot = Rotation()},
			no_shortcut_my_friend_a3 = {no_active = true, pos = Vector3(2930, 440, 0), rot = Rotation()},
			no_shortcut_my_friend_a4 = {no_active = true, pos = Vector3(2900, 440, 0), rot = Rotation()}
		}
		NoSenseDoor:Spawn_the_Door(spawn_list)
	end
	_fwb_ElementCounter_on_executed(self, instigator)
end