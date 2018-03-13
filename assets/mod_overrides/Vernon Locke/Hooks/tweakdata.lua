local _characters = table.size(tweak_data.criminals.characters) + 1
tweak_data.criminals.characters[_characters] = {
	name = "locke_player",
	order = _characters+1,
	static_data = {
		voice = "",
		ai_mask_id = "locke_player",
		ai_character_id = "ai_locke_player",
		ssuffix = "v"
	},
	body_g_object = Idstring("g_body")
}
_characters = nil
table.insert(tweak_data.criminals.character_names, "locke_player")