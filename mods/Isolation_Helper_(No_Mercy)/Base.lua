if Global.game_settings and Global.game_settings.level_id and Global.game_settings.level_id == "nmh" then
	_G.IsolationRoomHelper = _G.IsolationRoomHelper or {}
	IsolationRoomHelper.Ans = nil
	
	function IsolationRoomHelper:SetAns(pos)
		IsolationRoomHelper.Ans = pos
		return
	end
	
	function IsolationRoomHelper:WPON()
		managers.hud:add_waypoint(
			"nmh_IsolationRoomHelper", {
			icon = "pd2_talk",
			distance = true,
			position = self.Ans,
			no_sync = true,
			present_timer = 0,
			state = "present",
			radius = 50,
			color = Color.green,
			blend_mode = "add"
		})
		return
	end
	
	function IsolationRoomHelper:WPOFF()
		managers.hud:remove_waypoint("nmh_IsolationRoomHelper")
		return
	end
end