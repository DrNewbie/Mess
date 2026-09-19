Hooks:PostHook(TweakData, "init", "TaserFrag_TweakData", function(self, ...)
	self.projectiles.frag_taser = {}
	self.projectiles.frag_taser = deep_clone(self.projectiles.frag_com)
	self.projectiles.frag_taser.name_id = "bm_grenade_frag_taser"
end)