local locke_player_set_character_deployable = MenuSceneManager.set_character_deployable

function MenuSceneManager:set_character_deployable(...)
	if self._player_character_name == "ecp_male" then
		return
	end
	return locke_player_set_character_deployable(self, ...)
end