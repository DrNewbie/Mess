local FullyCharged_ModPath = ModPath

if ModCore then
	ModCore:new(FullyCharged_ModPath .. "Config.xml", true, true)
else
	Hooks:Add("LocalizationManagerPostInit", "FullyCharged_loc", function(loc)
		loc:load_localization_file(FullyCharged_ModPath.."Loc/EN.txt")
	end)
end