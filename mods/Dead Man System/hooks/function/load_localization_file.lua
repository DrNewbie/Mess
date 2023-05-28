local DeadManSysMain = _G.DeadManSysMain

if DeadManSysMain._hooks.load_localization_file then
	return
else
	DeadManSysMain._hooks.load_localization_file = true
end

Hooks:Add("LocalizationManagerPostInit", DeadManSysMain.__Name("load_localization_file"), function(loc)
	loc:load_localization_file(DeadManSysMain.ThisModPath.."/locs/en.json")
end)