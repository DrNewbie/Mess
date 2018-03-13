Hooks:PostHook(BlackMarketTweakData, "_init_characters", "locke_player_bm_init_characters", function(self, tweak_data)
	self.characters.locke_player = {
		fps_unit = "units/pd2_dlc_fo_sho/characters/npc_criminals_fo_sho/fps_locke_player_mover",
		npc_unit = "units/pd2_dlc_fo_sho/characters/npc_criminals_fo_sho/npc_criminal_locke_player",
		menu_unit = "units/pd2_dlc_fo_sho/characters/npc_criminals_fo_sho/npc_criminal_locke_player_menu",
		texture_bundle_folder = "fo_sho",
		sequence = "var_mtr_old_hoxton",
		mask_on_sequence = "mask_on",
		mask_off_sequence = "mask_off"
	}
	self.characters.ai_locke_player = {
		npc_unit = "units/pd2_dlc_fo_sho/characters/npc_criminals_fo_sho/fo_sho/npc_criminal_fo_sho",
		sequence = "var_mtr_old_hoxton",
		mask_on_sequence = "mask_on",
		mask_off_sequence = "mask_off"
	}
end)