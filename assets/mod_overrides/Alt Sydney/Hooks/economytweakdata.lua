Hooks:PostHook(EconomyTweakData, "init", "alt_sydney_ey_init", function(self)
	local orig = "units/pd2_dlc_alt_opera/characters/npc_criminals_fem_3/mtr_criminal_sydney"
	local cc = "units/pd2_dlc_alt_opera/characters/npc_criminals_fem_3/mtr_criminal_sydney_cc"
	self.armor_skins_configs[Idstring(orig):key()] = Idstring(cc)
	self.armor_skins_configs_map[Idstring(cc):key()] = Idstring(orig)	
	self.character_cc_configs.sydney_alt = Idstring("units/pd2_dlc_alt_opera/characters/npc_criminals_fem_3/mtr_criminal_sydney_cc")
end)