local ThisModPath = ModPath
local ThisModIds = Idstring(ThisModPath):key()
local Hook1 = "F_"..Idstring("Hook1::"..ThisModIds):key()

Hooks:PostHook(BlackMarketTweakData, "_init_projectiles", Hook1, function(self)
	self.projectiles.concussion.name_id = "bm_concussion_tf2_jarate"
	self.projectiles.concussion.desc_id = "bm_concussion_tf2_jarate_desc"
	self.projectiles.concussion.icon = nil
	self.projectiles.concussion.texture_bundle_folder = "tf2_jarate"
end)