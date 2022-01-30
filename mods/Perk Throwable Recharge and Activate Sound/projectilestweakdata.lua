local ThisModPath = ModPath or tostring(math.random())

Hooks:PostHook(BlackMarketTweakData, "_init_projectiles", "MOD1_"..Idstring(ThisModPath):key(), function(self)
	self.projectiles.smoke_screen_grenade.sounds = self.projectiles.smoke_screen_grenade.sounds or {}
	self.projectiles.smoke_screen_grenade.sounds.cooldown = "smoke_screen_grenade_cooldown"
	self.projectiles.smoke_screen_grenade.sounds.activate = "smoke_screen_grenade_activate"
	
	self.projectiles.pocket_ecm_jammer.sounds = self.projectiles.pocket_ecm_jammer.sounds or {}
	self.projectiles.pocket_ecm_jammer.sounds.cooldown = "pocket_ecm_jammer_cooldown"
end)