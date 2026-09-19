local ThisModPath = ModPath
local ThisModPathIds = Idstring(ThisModPath):key()
local func1 = "F_"..Idstring("func1::"..ThisModPathIds):key()

Hooks:PostHook(TimerGui, "update", func1, function(self, __unit, __t, __dt)
	if self._unit and self._unit:name():key() == "584bea03f3b5d712" and (self._jammed or not self._powered) then
		self._unit:set_local_rotation(self._unit:local_rotation() * Rotation(Vector3(0, 1, 0), __dt * 1000))
	end
end)