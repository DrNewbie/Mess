core:module("CoreElementRandom")
core:import("CoreMissionScriptElement")
core:import("CoreTable")
ElementRandom = ElementRandom or class(CoreMissionScriptElement.MissionScriptElement)

if not Global.game_settings or Global.game_settings.level_id ~= "mad" then
	return
end

if Network:is_client() then
	return
end

local _lhtd_ElementRandom_on_executed = ElementRandom.on_executed

function ElementRandom:on_executed(...)
	if tostring(self._id) == "100988" then
		return
	end
	_lhtd_ElementRandom_on_executed(self, ...)
end