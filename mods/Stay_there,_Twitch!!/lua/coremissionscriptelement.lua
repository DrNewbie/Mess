if Network:is_client() then
	return
end

if not Global.game_settings or Global.game_settings.level_id ~= "rat" then
	return
end

core:module("CoreMissionScriptElement")
core:import("CoreXml")
core:import("CoreCode")
core:import("CoreClass")

local _BLOCK_EVENT_102316 = MissionScriptElement.on_executed

function MissionScriptElement:on_executed(...)
	local _id = tostring(self._id)
	if _id == "102316" then
	else
		_BLOCK_EVENT_102316(self, ...)
	end
end
	