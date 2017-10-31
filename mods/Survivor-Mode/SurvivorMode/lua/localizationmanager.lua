_G.SurvivorModeBase = _G.SurvivorModeBase or {}

SurvivorModeBase.Enable = SurvivorModeBase.Enable or false

Hooks:Add("LocalizationManagerPostInit", "LocalizationManagerPostInit_SurvivorMode", function(loc)
	loc:load_localization_file( "loc/en.txt", false )
end)