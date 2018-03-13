Hooks:PostHook(EconomyTweakData, "init", "locke_player_ey_init", function(self)
	local orig = "units/pd2_dlc_fo_sho/characters/npc_criminals_fo_sho/mtr_criminal_locke_player"
	local cc = "units/pd2_dlc_fo_sho/characters/npc_criminals_fo_sho/mtr_criminal_locke_player_cc"
	self.armor_skins_configs[Idstring(orig):key()] = Idstring(cc)
	self.armor_skins_configs_map[Idstring(cc):key()] = Idstring(orig)	
	self.character_cc_configs.locke_player = Idstring("units/pd2_dlc_fo_sho/characters/npc_criminals_fo_sho/mtr_criminal_locke_player_cc")
end)