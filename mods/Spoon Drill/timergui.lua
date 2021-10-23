local mod_ids = Idstring("Spoon Drill"):key()
local func3 = "F_"..Idstring("func3::"..mod_ids):key()
local func4 = "F_"..Idstring("func4::"..mod_ids):key()

Hooks:PostHook(TimerGui, "update", func4, function(self, __unit, __t, __dt)
	if self._unit:base() and self._unit:base()[func3] then
		local __spoon = self._unit:base()[func3]
		if not self._jammed and self._powered then
			__spoon:set_local_rotation(__spoon:local_rotation() * Rotation(Vector3(0, 1, 0), __dt * 1000))
		end
	end
end)