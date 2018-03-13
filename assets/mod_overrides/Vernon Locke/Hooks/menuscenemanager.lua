local locke_player_set_character_deployable = MenuSceneManager.set_character_deployable

function MenuSceneManager:set_character_deployable(deployable_id, unit, peer_id)
	if self._player_character_name == "locke_player" then
		return
	end
	return locke_player_set_character_deployable(self, deployable_id, unit, peer_id)
end