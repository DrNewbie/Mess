core:import("CoreMissionScriptElement")
ElementSpawnCivilian = ElementSpawnCivilian or class(CoreMissionScriptElement.MissionScriptElement)

local UnlockableCharactersSys = _G.UnlockableCharactersSys

if UnlockableCharactersSys._hooks.block_in_safehouse_2 then
	return
else
	UnlockableCharactersSys._hooks.block_in_safehouse_2 = true
end

if not Global.game_settings or Global.game_settings.level_id ~= "chill" then
	return
end

if not UnlockableCharactersSys._funcs.__IsHost() then
	return
end

Hooks:PreHook(ElementSpawnCivilian, "on_executed", UnlockableCharactersSys.__Name("dont spawn in safehouse 2"), function(self, ...)
	if managers.job:current_job_id() == "chill" then
		if not UnlockableCharactersSys._funcs.IsThisCharacterUnLocked(self:editor_name()) then
			self._values.enabled = false
		end
	end
end)