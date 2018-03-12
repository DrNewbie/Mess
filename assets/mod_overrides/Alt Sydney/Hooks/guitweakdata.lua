Hooks:PostHook(EconomyTweakData, "_init_armor_skins", "alt_sydney_ey_init_armor_skins", function(self)
	table.insert(self.crime_net.codex[2], {
		{
			desc_id = "menu_alt_sydney_desc_codex",
			post_event = "pln_contact_sydney",
			videos = {"sydney1"}
		},
		name_id = "menu_alt_sydney",
		id = "sydney_alt"
	})
end)