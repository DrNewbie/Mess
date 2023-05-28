core:import("CoreMissionScriptElement")
ElementSpawnCivilian = ElementSpawnCivilian or class(CoreMissionScriptElement.MissionScriptElement)

local DeadManSysMain = _G.DeadManSysMain

if DeadManSysMain._hooks.block_in_safehouse_2 then
	return
else
	DeadManSysMain._hooks.block_in_safehouse_2 = true
end

if not DeadManSysMain._funcs.__IsHost() then
	return
end

if not Global.game_settings or Global.game_settings.level_id ~= "chill" then
	return
end

Hooks:PreHook(ElementSpawnCivilian, "on_executed", DeadManSysMain.__Name("dont spawn in safehouse 2"), function(self, ...)
	if managers.job:current_job_id() == "chill" then
		if DeadManSysMain._funcs.IsThisCharacterDead(self:editor_name()) then
			self._values.enabled = false
		end
	end
end)