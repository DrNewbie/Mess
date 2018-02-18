local PulverizerPD_ModPath = ModPath

if ModCore then
	ModCore:new(PulverizerPD_ModPath .. "Config.xml", true, true)
else
	Hooks:Add("LocalizationManagerPostInit", "PulverizerPD_loc", function(loc)
		loc:load_localization_file(PulverizerPD_ModPath.."Loc/EN.txt")
	end)
end