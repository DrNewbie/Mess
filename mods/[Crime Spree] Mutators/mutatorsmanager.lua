function MutatorsManager:can_mutators_be_active()
	if Global.game_settings.gamemode ~= GamemodeStandard.id and Global.game_settings.gamemode ~= "crime_spree" then
		return false
	end
	return true
end