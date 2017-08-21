local FourMaskAchievements_Breath_path = ModPath

Hooks:Add("LocalizationManagerPostInit", "LocalizationManagerPostInit_FourMaskAchievements", function(loc)
	loc:load_localization_file(FourMaskAchievements_Breath_path .. "loc/english.txt", false)
end)