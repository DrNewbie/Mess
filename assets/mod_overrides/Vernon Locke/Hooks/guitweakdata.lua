Hooks:PostHook(GuiTweakData, "init", "locke_player_gui_init", function(self)
	table.insert(self.crime_net.codex[2], {
		{
			desc_id = "heist_contact_locke_description",
			post_event = "loc_quote_set_a",
			videos = {"locke1"}
		},
		name_id = "menu_locke_player",
		id = "locke_player"
	})
end)