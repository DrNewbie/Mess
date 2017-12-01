core:import("CoreMissionScriptElement")
ElementPlayerCharacterFilter = ElementPlayerCharacterFilter or class(CoreMissionScriptElement.MissionScriptElement)

if not Global.game_settings or Global.game_settings.level_id ~= "chill" then
	return
end

local SNS_CharacterFilter = ElementPlayerCharacterFilter.on_executed

function ElementPlayerCharacterFilter:on_executed(...)
	if not self._values.enabled then
		return
	end
	if Global.game_settings.level_id == "chill" then
		if managers.criminals:is_not_at_home(self:value("character")) then
			return
		end
	end
	SNS_CharacterFilter(self, ...)
end