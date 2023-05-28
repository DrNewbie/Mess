local DeadManSysMain = _G.DeadManSysMain

if DeadManSysMain._hooks.reset_dead_man then
	return
else
	DeadManSysMain._hooks.reset_dead_man = true
end

Hooks:PostHook(MenuManager, "do_clear_progress", DeadManSysMain.__Name("do_clear_progress"), function(self, ...)
	DeadManSysMain._funcs.__Clear()
end)
