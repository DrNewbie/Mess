local RemoteC4_ModPath = ModPath

if ModCore then
	ModCore:new(RemoteC4_ModPath .. "Config.xml", true, true)
else
	Hooks:Add("LocalizationManagerPostInit", "RemoteC4_Loc", function(loc)
		loc:load_localization_file(RemoteC4_ModPath.."Loc/EN.txt")
	end)
end