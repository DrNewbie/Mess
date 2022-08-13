local ThisModPath = ModPath
local ThisModIds = Idstring(ThisModPath):key()

core:module("CoreMissionScriptElement")
core:import("CoreXml")
core:import("CoreCode")
core:import("CoreClass")
MissionScriptElement = MissionScriptElement or class()

local Hook1 = "F_"..Idstring("on_executed::"..ThisModIds):key()
local Hook2 = "F_"..Idstring("is_bool::"..ThisModIds):key()
local ThisPackage = "packages/pda9_piggybank"

_G[Hook2] =_G[Hook2] or false

Hooks:PostHook(MissionScriptElement, "on_executed", Hook1, function(self, ...)
	if not _G[Hook2] and self._id == 100014 and (not Network or (Network and not Network:is_client())) and Global.game_settings and Global.game_settings.level_id == "chill" then
		_G[Hook2] = true
		if PackageManager:package_exists(ThisPackage) and PackageManager:loaded(ThisPackage) then
			World:spawn_unit(Idstring("units/pd2_dlc_pda9/props/pda9_piggybank/pda9_prop_piggybank_level_1"), Vector3(115, 335, 48), Rotation())
		end
	end
end)

if PackageManager:package_exists(ThisPackage) and not PackageManager:loaded(ThisPackage) then
	PackageManager:load(ThisPackage)
end