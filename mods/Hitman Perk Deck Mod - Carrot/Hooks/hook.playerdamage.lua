local ThisModPath = ModPath
local ThisModIds = Idstring(ThisModPath):key()
local __Dt = "DT_"..Idstring("__Dt::"..ThisModIds):key()

Hooks:PostHook(PlayerDamage, "update", "F_"..Idstring("PlyDmg:update::"..ThisModIds):key(), function(self, __unit, __t, __dt)
	self[__Dt] = self[__Dt] or 0
	if self:_max_armor() > 0 then
		self[__Dt] = self[__Dt] + __dt
		if self[__Dt] >= 2.5 then
			self[__Dt] = 0
			self:_regenerate_armor()
		end
	end
end)