local ThisModPath = ModPath

local __Name = function(__id)
	return "JJJ_"..Idstring(tostring(__id).."::"..ThisModPath):key()
end

local OldPos = __Name(1)
local OldRot = __Name(2)
local IsBool = __Name(3)
local IsMove = __Name(4)

local function __RRRnd()
	math.randomseed()
	math.randomseed()
	math.randomseed()
	math.randomseed()
	math.randomseed()
	math.random()
	math.random()
	math.random()
	math.random()
	math.random()
	return
end

local function __PickRnd()
	__RRRnd()
	return (math.random())
end

local function __PickPN()
	__RRRnd()
	return ((math.random(1,2)*2)-3)
end

Hooks:PostHook(TimerGui, "update", __Name(5), function(self, ...)
	if self._unit and self._unit:name():key() == "584bea03f3b5d712" and not self[IsBool] then
		self[OldPos] = self._unit:local_position()
		self[OldRot] = self._unit:local_rotation()
		self[IsBool] = true
		self[IsMove] = false
	end
end)

Hooks:PostHook(TimerGui, "update", __Name(6), function(self, __unit, __t, __dt, ...)
	if self._unit and alive(self._unit) and self[IsBool] and self[OldPos] and self[OldRot] then
		if self._jammed then
			local RotToX, RotToY, RotToZ = __PickRnd(), __PickRnd(), __PickRnd()
			local PosToX, PosToY, PosToZ = __PickRnd()*20*__PickPN(), __PickRnd()*20*__PickPN(), __PickRnd()*20*__PickPN()
			self._unit:set_local_rotation(
				self._unit:local_rotation() * Rotation(Vector3(RotToX, RotToY, RotToZ), __dt * 1000)
			)
			self._unit:set_local_position(
				self[OldPos] + Vector3(PosToX, PosToY, PosToZ)
			)
			self[IsMove] = true
		elseif self[IsMove] then
			self[IsMove] = false
			self._unit:set_local_position(self[OldPos])
			self._unit:set_local_rotation(self[OldRot])
		end
	end
end)