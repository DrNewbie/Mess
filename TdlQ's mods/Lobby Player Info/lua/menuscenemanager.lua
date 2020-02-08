local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local lpi_original_menuscenemanager_characterscreenposition = MenuSceneManager.character_screen_position
function MenuSceneManager:character_screen_position(peer_id)
	if LobbyPlayerInfo.settings.keep_pre68_character_name_position then
		local unit = self._lobby_characters[peer_id]
		if unit and alive(unit) then
			local peer_3_x_offset = 0
			if peer_id == 3 then
				local is_me = peer_id == managers.network:session():local_peer():id()
				peer_3_x_offset = is_me and -20 or -40
			end
			local spine_pos = unit:get_object(Idstring("Spine")):position() + Vector3(peer_3_x_offset, 0, 5 * (peer_id % 4))
			return self._workspace:world_to_screen(self._camera_object, spine_pos)
		end
	else 
		return lpi_original_menuscenemanager_characterscreenposition(self, peer_id)
	end
end
