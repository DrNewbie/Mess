_G.GoodWillSysMain = _G.GoodWillSysMain or {}

if _G.GoodWillSysMain._hooks.load_localization_file then
	return
else
	_G.GoodWillSysMain._hooks.load_localization_file = true
end

Hooks:Add("LocalizationManagerPostInit", _G.GoodWillSysMain.__Name("load_localization_file"), function(loc)
	loc:load_localization_file(_G.GoodWillSysMain.ThisModPath.."/locs/en.json")
end)