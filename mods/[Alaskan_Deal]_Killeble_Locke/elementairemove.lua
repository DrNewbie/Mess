core:import("CoreMissionScriptElement")

ElementAIRemove = ElementAIRemove or class(CoreMissionScriptElement.MissionScriptElement)

if not Global.game_settings or not Global.game_settings.level_id or not Global.game_settings.level_id == "wwh" then
	return
end

local SafeKillFoSho_ElementAIRemove_on_executed = ElementAIRemove.on_executed

function ElementAIRemove:on_executed(...)
	if not self._values.enabled then
		return
	end
	if self._id == 100680 and self._editor_name == "ai_remove_003" then
		for _, id in ipairs(self._values.elements) do
			local element = self:get_mission_element(id)
			local _units = element and element._units or {}
			for _, _u in pairs(_units) do
				if _u and alive(_u) and _u:name():key() == "e02ee034fa8dc24a" then
					if _u.character_damage and _u:character_damage() and not _u:character_damage():dead() then
					
					else
						managers.experience:mission_xp_award(9999)
						return
					end
				end
			end
		end
	end	
	SafeKillFoSho_ElementAIRemove_on_executed(self, ...)
end
