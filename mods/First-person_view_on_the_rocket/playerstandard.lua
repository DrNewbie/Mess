--[[
_G.FPVOTR = _G.FPVOTR or {}

Hooks:PostHook(PlayerStandard, "_update_movement", "FPVOTR_PlayerStandard_update_movement", function(self, ...)
	if self._move_dir then
		if FPVOTR and FPVOTR.O_CAMERA and FPVOTR.CAMERA and FPVOTR.CAMERA._tp_camera_object then
			if FPVOTR.Attach_Unit then
				if alive(FPVOTR.Attach_Unit) then
					self._con = self._con or managers.controller:get_controller_by_name("freeflight") or managers.controller:create_controller("freeflight", nil, true, 10)
					local axis_move = self._con:get_input_axis("freeflight_axis_move")
					local axis_look = self._con:get_input_axis("freeflight_axis_look")
					local btn_move_up = self._con:get_input_float("freeflight_move_up")
					local btn_move_down = self._con:get_input_float("freeflight_move_down")
					local move_dir = FPVOTR.O_CAMERA:rotation():x() * axis_move.x + FPVOTR.O_CAMERA:rotation():y() * axis_move.y
					move_dir = move_dir + btn_move_up * Vector3(0, 0, 1) + btn_move_down * Vector3(0, 0, -1)
					log(tostring(axis_move))
					log(tostring(axis_look))
					log(tostring(btn_move_up))
					log(tostring(btn_move_down))
					--FPVOTR.Attach_Unit:push_at(1, push_vec, FPVOTR.Attach_Unit:position())
				end
			else
				
			end
		end
	end
end)
]]