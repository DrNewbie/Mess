core:import("CoreMissionScriptElement")
ElementMandatoryBags = ElementMandatoryBags or class(CoreMissionScriptElement.MissionScriptElement)

if not Global.game_settings or Global.game_settings.level_id ~= "red2" then
	return
end

if Network:is_client() then
	return
end

_G.NoSenseDoor = _G.NoSenseDoor or {}

local NoSenseDoor = _G.NoSenseDoor or {}

local _fwb_ElementMandatoryBags_on_executed = ElementMandatoryBags.on_executed

function ElementMandatoryBags:on_executed(...)
	local _id = tostring(self._id)
	if (_id == "105019" or _id == "103032" or _id == "103033") then
		self._values.amount = 12
	end
	_fwb_ElementMandatoryBags_on_executed(self, ...)
end