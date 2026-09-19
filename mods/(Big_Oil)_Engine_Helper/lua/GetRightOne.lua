core:module("CoreMissionScriptElement")
core:import("CoreXml")
core:import("CoreCode")
core:import("CoreClass")

_G.EngineHelper = _G.EngineHelper or {}

EngineHelper = _G.EngineHelper or {}

if not Global.game_settings or Global.game_settings.level_id ~= "welcome_to_the_jungle_2" then
	return
end

local EngineHelper_GetCorrectOne = MissionScriptElement.on_executed

function MissionScriptElement:on_executed(...)
	if not Global.game_settings or Global.game_settings.level_id ~= "welcome_to_the_jungle_2" or not EngineHelper then
	
	else
		local _id = 'id_' .. self._id
		local PossibleOne = {
			id_103703 = Vector3(-1830, -2182, -313.492),
			id_103704 = Vector3(-1200, -2050, -313.492),
			id_103705 = Vector3(-1849, -1869, -313.492),
			id_103706 = Vector3(-1200, -1735, -313.492),
			id_103707 = Vector3(-1849, -1429, -313.492),
			id_103708 = Vector3(-1200, -1415, -313.492),
			id_103709 = Vector3(-175, -2025, -313.492),
			id_103711 = Vector3(24.9999, -1350, -313.492),
			id_103714 = Vector3(-175, -1675, -313.492),
			id_103715 = Vector3(35, -1733, -314),
			id_103716 = Vector3(-175, -1350, -313.492),
			id_103717 = Vector3(25, -2050, -313.492)
		}
		if PossibleOne[_id] then
			EngineHelper.CorrectOne = PossibleOne[_id]
		end
	end
	return EngineHelper_GetCorrectOne(self, ...)
end