local CriticalPerk_ModPath = ModPath

if ModCore then
	ModCore:new(CriticalPerk_ModPath .. "Config.xml", true, true)
else
	Hooks:Add("LocalizationManagerPostInit", "CriticalPerk_loc", function(loc)
		loc:load_localization_file(CriticalPerk_ModPath.."Loc/EN.txt")
	end)
end