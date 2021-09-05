local ThisModPath = ModPath
local mod_ids = Idstring(ThisModPath):key()
local func1 = "F_"..Idstring("func1::"..mod_ids):key()
local func3 = "F_"..Idstring("func3::"..mod_ids):key()
local func4 = "F_"..Idstring("func4::"..mod_ids):key()

Hooks:PostHook(TimerGui, "update", func4, function(self, unit, t, dt)
	if self._unit and self._unit:name():key() == "584bea03f3b5d712" and self._unit:base() and (self._jammed or not self._powered) then
		self._unit:set_local_rotation(Rotation(0, 0, (t*1000)%255))
	end
end)