if BlackMarketTweakData then
	Hooks:PostHook(BlackMarketTweakData, "_init_player_styles", "F_"..Idstring("Post.BlackMarketTweakData._init_player_styles.is_christmas_heist"):key(), function(self)
		local function set_characters_data(player_style, characters, data)
			self.player_styles[player_style].characters = self.player_styles[player_style].characters or {}
			for _, key in pairs(characters) do
				self.player_styles[player_style].characters[key] = data
			end
		end
		local a1, a2, a3, a4 = self:_get_character_groups()
		set_characters_data("tux", a1, self.player_styles.tux.characters.dallas)
		set_characters_data("tux", a2, self.player_styles.tux.characters.dallas)
		set_characters_data("tux", a3, self.player_styles.tux.characters.dallas)
		set_characters_data("tux", a4, self.player_styles.tux.characters.dallas)
	end)
end