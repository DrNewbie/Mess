Hooks:Add("MenuManagerOnOpenMenu", "Ask_Run_DelOld_Now", function(self, menu, ...)
	if menu == "menu_main" then
		local function Ask_Run_DelOld(days, del_logs, del_dump)
			local base_path = Application:base_path() .. ""
			base_path = base_path:gsub('\\PAYDAY 2\\', '\\PAYDAY 2')
			local log_files = Application:nice_path(base_path .. "/mods/logs", false)
			if del_logs then
				os.execute(string.format('forfiles -P "%s" -S -M *.txt /D -%d /C "cmd /c del @path"', log_files, days))
			end
			if del_dump then
				os.execute(string.format('forfiles -P "%s" -S -M *.mdmp /D -%d /C "cmd /c del @path"', base_path, days))
			end
		end
		Ask_Run_DelOld(3, true, true)
	end
end)