local Henchmen_Cabletier_ModPath = ModPath

Hooks:Add("LocalizationManagerPostInit", "LocalizationManagerPostInit_Henchmen_Cabletier", function(loc)
	loc:load_localization_file(Henchmen_Cabletier_ModPath .. "loc/english.txt", false)
end)