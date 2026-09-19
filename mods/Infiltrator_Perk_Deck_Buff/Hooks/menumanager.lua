local ThisModPath = ModPath

Hooks:Add("LocalizationManagerPostInit", "M_"..Idstring("LocalizationManagerPostInit:Infiltrator Perk Deck Buff"):key(), function(loc)
	loc:load_localization_file(ThisModPath.."Loc/english.txt")
end)