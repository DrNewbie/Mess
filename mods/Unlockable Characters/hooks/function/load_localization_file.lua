local UnlockableCharactersSys = _G.UnlockableCharactersSys

if UnlockableCharactersSys._hooks.load_localization_file then
	return
else
	UnlockableCharactersSys._hooks.load_localization_file = true
end

Hooks:Add("LocalizationManagerPostInit", UnlockableCharactersSys.__Name("load_localization_file"), function(loc)
	loc:load_localization_file(UnlockableCharactersSys.ThisModPath.."/locs/en.json")
end)