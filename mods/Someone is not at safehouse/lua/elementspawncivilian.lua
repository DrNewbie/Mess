core:import("CoreMissionScriptElement")
ElementPlayerCharacterFilter = ElementPlayerCharacterFilter or class(CoreMissionScriptElement.MissionScriptElement)

if not Global.game_settings or Global.game_settings.level_id ~= "chill" then
	return
end

local SNS_Civilian = ElementSpawnCivilian.on_executed

function ElementSpawnCivilian:on_executed(...)
	if not self._values.enabled then
		return
	end	
	if Global.game_settings.level_id == "chill" then
		if managers.criminals:is_not_at_home(tostring(self:editor_name())) then
			return
		end
	end
	SNS_Civilian(self, ...)
end