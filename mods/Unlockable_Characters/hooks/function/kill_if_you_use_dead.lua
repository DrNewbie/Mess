local UnlockableCharactersSys = _G.UnlockableCharactersSys

if UnlockableCharactersSys._hooks.kill_if_you_use_dead then
	return
else
	UnlockableCharactersSys._hooks.kill_if_you_use_dead = true
end

--[[	--don't need
if not UnlockableCharactersSys._funcs.__IsHost() then
	return
end
]]

Hooks:PostHook(PlayerDamage, "update", UnlockableCharactersSys.__Name("dead man walking"), function(self, ...)
	if self._unit and alive(self._unit) and not self:is_downed() and managers.criminals then
		local __name = managers.criminals:character_name_by_unit(self._unit)
		if __name and not UnlockableCharactersSys._funcs.IsThisCharacterUnLocked(__name) then
			self._revives = Application:digest_value(0, true)
			self:force_into_bleedout(false, false)
			self._downed_timer = 0.1
			if managers.hud then
				managers.hud:show_hint({
					text = managers.localization:text("pdstory_ingame_locked_hint"),
					time = 10
				})
			end
		end
	end
end)