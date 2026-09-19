local Henchmen_Dragons_Breath_path = ModPath

Hooks:Add("LocalizationManagerPostInit", "LocalizationManagerPostInit_Henchmen_Dragons_Breath", function(loc)
	loc:load_localization_file(Henchmen_Dragons_Breath_path .. "loc/english.txt", false)
end)