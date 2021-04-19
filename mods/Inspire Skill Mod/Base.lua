local ThisModPath = ModPath


Hooks:Add("LocalizationManagerPostInit", "InspireSkillModLoadLoc", function(loc)
	loc:load_localization_file(ThisModPath.."en.loc.json")
end)