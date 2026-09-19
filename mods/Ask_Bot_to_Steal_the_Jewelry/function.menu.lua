_G.AskBot2Stealth_Mneu = _G.AskBot2Stealth_Mneu or {}

AskBot2Stealth_Mneu.ModPath = AskBot2Stealth_Mneu.ModPath or ModPath

AskBot2Stealth_Mneu._data = {}

Hooks:Add("LocalizationManagerPostInit", "Localization_AskBot2StealthMenu", function(loc)
	loc:load_localization_file(AskBot2Stealth_Mneu.ModPath.."loc.english.txt", false)
end)

Hooks:Add("MenuManagerInitialize", "MenManIni_AskBot2StealthMenu", function(menu_manager)
	function MenuCallbackHandler:AskBot2StealthRun()
		dofile(AskBot2Stealth_Mneu.ModPath..'hook.playerstandard.lua')
		dofile(AskBot2Stealth_Mneu.ModPath..'hook.groupaistatebase.lua')
	end
	MenuHelper:LoadFromJsonFile(AskBot2Stealth_Mneu.ModPath.."settings.menu.json", AskBot2Stealth_Mneu, AskBot2Stealth_Mneu._data)
end)

if ModCore then
	ModCore:new(AskBot2Stealth_Mneu.ModPath.."updater.xml", false, true):init_modules()
end