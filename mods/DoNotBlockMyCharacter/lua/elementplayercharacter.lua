core:import("CoreMissionScriptElement")
ElementPlayerCharacterTrigger = ElementPlayerCharacterTrigger or class(CoreMissionScriptElement.MissionScriptElement)

function ElementPlayerCharacterFilter:on_executed(instigator)
	if not self._values.enabled then
		return
	end
	local char_taken = self:is_character_taken(instigator)
	local require_char = self:value("require_presence")
	if Global.game_settings.level_id ~= "chill" then
		if char_taken and not require_char or require_char and not char_taken then
			return
		end
	end
	ElementPlayerStateTrigger.super.on_executed(self, self._unit or instigator)
end