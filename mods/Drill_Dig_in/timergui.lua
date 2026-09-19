local ThisModPath = ModPath
local ThisModPathIds = Idstring(ThisModPath):key()
local func1 = "F_"..Idstring("func1::"..ThisModPathIds):key()
local func2 = "F_"..Idstring("func2::"..ThisModPathIds):key()
local time1 = "T_"..Idstring("time1::"..ThisModPathIds):key()
local bool1 = "B_"..Idstring("bool1::"..ThisModPathIds):key()
local _pos1 = "P_"..Idstring("_pos1::"..ThisModPathIds):key()
local _pos2 = "P_"..Idstring("_pos2::"..ThisModPathIds):key()
local _pos3 = "P_"..Idstring("_pos3::"..ThisModPathIds):key()

Hooks:PostHook(TimerGui, "_start", func2, function(self)
	if self._unit and self._unit:name():key() == "584bea03f3b5d712" then
		self[bool1] = true
		self[time1] = self._time_left
		self[_pos1] = self._unit:get_object(Idstring("g_drill_drill")):local_position()
		self[_pos2] = self._unit:get_object(Idstring("g_drill")):local_position()
		self[_pos3] = Vector3(0, 18, 0)
	end
end)

Hooks:PostHook(TimerGui, "update", func1, function(self, __unit, __t, __dt)
	if self._unit and self[bool1] then
		if self._jammed or not self._powered then
		
		else
			if type(self._time_left) == "number" and self._time_left > 0 then
				local __time_rate = math.max(1 - self._time_left/self[time1], 0)
				local __g_drill_drill = self._unit:get_object(Idstring("g_drill_drill"))
				local __g_drill = self._unit:get_object(Idstring("g_drill"))
				if __g_drill_drill and __g_drill then
					__g_drill_drill:set_local_position(self[_pos1] - self[_pos3] * __time_rate)
					__g_drill:set_local_position(self[_pos2] - self[_pos3] * __time_rate)
				end
			end
		end
	end
end)