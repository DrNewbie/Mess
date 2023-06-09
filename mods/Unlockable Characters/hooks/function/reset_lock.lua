local UnlockableCharactersSys = _G.UnlockableCharactersSys

if UnlockableCharactersSys._hooks.reset_lock then
	return
else
	UnlockableCharactersSys._hooks.reset_lock = true
end

Hooks:PostHook(MenuManager, "do_clear_progress", UnlockableCharactersSys.__Name("do_clear_progress"), function(self, ...)
	UnlockableCharactersSys._funcs.__Clear()
end)
