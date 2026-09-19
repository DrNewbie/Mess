local ThisModPath = tostring(ModPath)
local __NameIds = function(__data)
	return "SGP_"..Idstring(ThisModPath..string.format("%q", __data)):key()
end
local old_pos = __NameIds("old_pos")
local flow_offset = 8
local flow_offset_moving = flow_offset + 1
local flow_offset_speed = 166
local spin_speed = 333

Hooks:PostHook(GageAssignmentBase, "init", __NameIds("init"), function(self, __unit, ...)
	self._unit:set_local_position(self._unit:local_position() + Vector3(0, 0, flow_offset))
	self[old_pos] = self._unit:local_position()
	__unit:set_extension_update_enabled(Idstring("base"), true)
end)

function GageAssignmentBase:update(__unit, __t, __dt, ...)
	if self._unit and alive(self._unit) and type(__t) == "number" and type(__dt) == "number" then
		self._unit:set_local_rotation(self._unit:local_rotation() * Rotation(Vector3(0, 0, 1), __dt * spin_speed))
		if self[old_pos] then
			self._unit:set_local_position(self[old_pos] + Vector3(0, 0, math.sin(__t*flow_offset_speed) * flow_offset_moving))
		end
	end
end