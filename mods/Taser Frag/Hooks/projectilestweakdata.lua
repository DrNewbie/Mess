Hooks:PostHook(BlackMarketTweakData, "_init_projectiles", "TaserFrag_BMTweakData", function(self, ...)
	self.projectiles.frag_taser = {}
	self.projectiles.frag_taser = deep_clone(self.projectiles.frag_com)
	self.projectiles.frag_taser.name_id = "bm_grenade_frag_taser"
	self.projectiles.frag_taser.desc_id = "bm_grenade_frag_taser_desc"
	self.projectiles.frag_taser.unit = "units/payday2/weapons/wpn_frag_grenade_com/wpn_frag_grenade_taser"
	
	table.insert(self._projectiles_index, "frag_taser")
end)