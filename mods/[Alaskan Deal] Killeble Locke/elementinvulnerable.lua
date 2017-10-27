core:import("CoreMissionScriptElement")

ElementInvulnerable = ElementInvulnerable or class(CoreMissionScriptElement.MissionScriptElement)

if not Global.game_settings or not Global.game_settings.level_id or not Global.game_settings.level_id == "wwh" then
	return
end

local SafeKillFoSho_ElementInvulnerable_on_executed = ElementInvulnerable.on_executed

function ElementInvulnerable:on_executed(...)
	if not self._values.enabled then
		return
	end
	if self._id == 100686 and self._editor_name == "func_invulnerable_001" then
		return
	end
	SafeKillFoSho_ElementInvulnerable_on_executed(self, ...)
end
