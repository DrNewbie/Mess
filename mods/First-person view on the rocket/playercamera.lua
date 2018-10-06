_G.FPVOTR = _G.FPVOTR or {}

Hooks:PostHook(PlayerCamera, "init", "FPVOTR_PlayerCamera_init", function(self)
	self._tp_camera_object = World:create_camera()
	self._tp_camera_object:set_near_range(3)
	self._tp_camera_object:set_far_range(250000)
	self._tp_camera_object:set_fov(75)
	FPVOTR.O_CAMERA = self._camera_object
	FPVOTR.CAMERA = self
end)

function PlayerCamera:set_FOV(fov_value)
	self._camera_object:set_fov(fov_value)
	self._tp_camera_object:set_fov(fov_value)
end

Hooks:PostHook(PlayerCamera, "update", "FPVOTR_PlayerCamera_update", function(self, unit, t, dt)
	if FPVOTR and FPVOTR.O_CAMERA and FPVOTR.CAMERA and FPVOTR.CAMERA._tp_camera_object then
		if FPVOTR.Attach_Unit then
			if alive(FPVOTR.Attach_Unit) then
				if not FPVOTR.Attaching then
					FPVOTR.Attaching = true
					self._tp_camera_object:link(self._camera_object)
					self._vp:set_camera(self._tp_camera_object)
				end
				self._tp_camera_object:set_position(FPVOTR.Attach_Unit:position() + Vector3(0, 0, 10))
				self._tp_camera_object:set_rotation(FPVOTR.Attach_Unit:rotation())
			else
				if not FPVOTR.Ready2Back then
					FPVOTR.Ready2Back = 2
				else
					FPVOTR.Ready2Back = FPVOTR.Ready2Back - dt
					if FPVOTR.Ready2Back <= 0 then
						FPVOTR.Ready2Back = nil
						FPVOTR.Attach_Unit = nil
						FPVOTR.Attaching = nil
						self._vp:set_camera(FPVOTR.O_CAMERA)					
					end
				end
			end
		else
			
		end
	end
end)