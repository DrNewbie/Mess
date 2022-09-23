local ThisModPath = ModPath
local ThisModPathIds = Idstring(ThisModPath):key()
local Hook1 = "F_"..Idstring("Hook1::"..ThisModPathIds):key()
local Hook2 = "F_"..Idstring("Hook2::"..ThisModPathIds):key()
local Bool1 = "F_"..Idstring("Bool1::"..ThisModPathIds):key()
local Time1 = "F_"..Idstring("Time1::"..ThisModPathIds):key()

Hooks:PreHook(ShotgunBase, "setup_default", Hook2, function(self)
	if tostring(self._name_id) == "sko12" then
		self[Bool1] = true
		self[Time1] = 0
	end
end)

Hooks:PreHook(ShotgunBase, "_fire_raycast", Hook2, function(self)
	if self[Bool1] then
		self[Time1] = self[Time1] + 1
		if self[Time1] == 3 then
			self._bullet_class = CoreSerialize.string_to_classtable("InstantExplosiveBulletBase")
			self._bullet_slotmask = self._bullet_class:bullet_slotmask()
			self._blank_slotmask = self._bullet_class:blank_slotmask()
		elseif self[Time1] > 3 then
			self[Time1] = 1
			self._bullet_class = CoreSerialize.string_to_classtable("InstantBulletBase")
			self._bullet_slotmask = self._bullet_class:bullet_slotmask()
			self._blank_slotmask = self._bullet_class:blank_slotmask()
		end
	end
end)