core:import("CoreMissionScriptElement")
ElementPlayerCharacterFilter = ElementPlayerCharacterFilter or class(CoreMissionScriptElement.MissionScriptElement)

local UnlockableCharactersSys = _G.UnlockableCharactersSys

if UnlockableCharactersSys._hooks.block_in_safehouse_1 then
	return
else
	UnlockableCharactersSys._hooks.block_in_safehouse_1 = true
end

if not Global.game_settings or Global.game_settings.level_id ~= "chill" then
	return
end

if not UnlockableCharactersSys._funcs.__IsHost() then
	return
end

Hooks:PreHook(ElementPlayerCharacterFilter, "on_executed", UnlockableCharactersSys.__Name("dont spawn in safehouse 1"), function(self, ...)
	if managers.job:current_job_id() == "chill" then
		if not UnlockableCharactersSys._funcs.IsThisCharacterUnLocked(self:value("character")) then
			self._values.enabled = false
		end
	end
end)