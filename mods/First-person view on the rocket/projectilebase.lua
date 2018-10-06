_G.FPVOTR = _G.FPVOTR or {}

Hooks:PreHook(ProjectileBase, "update", "FPVOTR_PlayerCamera_update", function(self, unit, t, dt)
	if tostring(self._projectile_entry) == "rocket_frag" and FPVOTR and FPVOTR.CAMERA and FPVOTR.CAMERA._tp_camera_object then
		if not FPVOTR.Attach_Unit then
			FPVOTR.Attach_Unit = self._unit
		end
	end
end)