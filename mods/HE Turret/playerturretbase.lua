local ThisModPath = ModPath
local ThisModIds = Idstring(ThisModPath):key()
local __Name = function(__id)
	return "HET_"..Idstring(tostring(__id).."::"..ThisModIds):key()
end

Hooks:PostHook(PlayerTurretBase, "init", __Name("init"), function(self, ...)
	self._bullet_class = InstantExplosiveBulletBase
	self._bullet_slotmask = self._bullet_class:bullet_slotmask()
	self._blank_slotmask = self._bullet_class:blank_slotmask()
end)