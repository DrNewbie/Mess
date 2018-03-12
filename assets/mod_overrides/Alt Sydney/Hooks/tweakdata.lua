local _characters = table.size(tweak_data.criminals.characters) + 1
tweak_data.criminals.characters[_characters] = {
	name = "sydney_alt",
	order = _characters+1,
	static_data = {
		voice = "rb15",
		ai_mask_id = "sydney_alt",
		ai_character_id = "ai_sydney_alt",
		ssuffix = "v"
	},
	body_g_object = Idstring("g_body")
}
_characters = nil
table.insert(tweak_data.criminals.character_names, "sydney_alt")