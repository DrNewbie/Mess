local ThisModPath = ModPath

Hooks:Add("LocalizationManagerPostInit", "M_"..Idstring("LocalizationManagerPostInit:Gambler Perk Deck Buff"):key(), function(loc)
	loc:load_localization_file(ThisModPath.."Loc/english.txt")
end)