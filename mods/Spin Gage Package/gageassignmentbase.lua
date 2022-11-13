local ThisModPath = tostring(ModPath)
local __NameIds = function(__data)
	return "SGP_"..Idstring(ThisModPath..string.format("%q", __data)):key()
end

Hooks:PostHook(GageAssignmentBase, "init", __NameIds("init"), function(self, __unit, ...)
	__unit:set_extension_update_enabled(Idstring("base"), true)
end)

function GageAssignmentBase:update(__unit, __t, __dt, ...)
	if self._unit and alive(self._unit) and type(__dt) == "number" then
		self._unit:set_local_rotation(self._unit:local_rotation() * Rotation(Vector3(0, 0, 1), __dt * 333))
	end
end