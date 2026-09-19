if Global.game_settings and Global.game_settings.level_id and Global.game_settings.level_id == "hox_2" then
	_G.CaseFilesHelper = _G.CaseFilesHelper or {}
	CaseFilesHelper.Ans = nil
	
	function CaseFilesHelper:SetAns(pos)
		CaseFilesHelper.Ans = pos
		return
	end
	
	function CaseFilesHelper:WPON()
		managers.hud:add_waypoint(
			"hb_day2_CaseFilesHelper", {
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
	
	function CaseFilesHelper:WPOFF()
		managers.hud:remove_waypoint("hb_day2_CaseFilesHelper")
		return
	end
end