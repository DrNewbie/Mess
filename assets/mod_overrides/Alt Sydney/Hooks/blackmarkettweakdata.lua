Hooks:PostHook(BlackMarketTweakData, "_init_characters", "alt_sydney_bm_init_characters", function(self, tweak_data)
	self.characters.sydney_alt = {
		fps_unit = "units/pd2_dlc_alt_opera/characters/npc_criminals_fem_3/fps_sydney_mover",
		npc_unit = "units/pd2_dlc_alt_opera/characters/npc_criminals_fem_3/npc_criminal_sydney",
		menu_unit = "units/pd2_dlc_alt_opera/characters/npc_criminals_fem_3/npc_criminal_sydney_menu",
		texture_bundle_folder = "alt_opera",
		sequence = "var_mtr_sydney",
		mask_on_sequence = "mask_on",
		mask_off_sequence = "mask_off",
		dlc = "opera"
	}
	self.characters.ai_sydney_alt = {
		npc_unit = "units/pd2_dlc_alt_opera/characters/npc_criminals_fem_3/fem3/npc_criminal_female_3",
		sequence = "var_mtr_sydney",
		mask_on_sequence = "mask_on",
		mask_off_sequence = "mask_off"
	}
end)