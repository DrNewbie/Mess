local ThisModPath = ModPath
local ThisModIds = Idstring(ThisModPath):key()
local Hook1 = "F_"..Idstring("Hook1::"..ThisModIds):key()

Hooks:PostHook(BlackMarketTweakData, "_init_projectiles", Hook1, function(self)
	self.projectiles.concussion.name_id = "bm_concussion_9_bang"
	self.projectiles.concussion.desc_id = "bm_concussion_9_bang_desc" 
end)