if Global.game_settings and Global.game_settings.level_id and Global.game_settings.level_id == "hox_1" then
	_G.ControlRoomHelper = _G.ControlRoomHelper or {}
	ControlRoomHelper.Ans = nil
	
	function ControlRoomHelper:SetAns(pos)
		ControlRoomHelper.Ans = pos
	end
	
	function ControlRoomHelper:WPON()
		managers.hud:add_waypoint(
			"hb_day1_controlroomhelper", {
			icon = "pd2_door",
			distance = true,
			position = self.Ans,
			no_sync = true,
			present_timer = 0,
			state = "present",
			radius = 50,
			color = Color.green,
			blend_mode = "add"
		})
	end
	
	function ControlRoomHelper:WPOFF()
		managers.hud:remove_waypoint("hb_day1_controlroomhelper")
	end
end