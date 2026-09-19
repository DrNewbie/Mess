if Global.game_settings and Global.game_settings.level_id and Global.game_settings.level_id == "kenaz" then
	_G.ArchivesHelperGGC = _G.ArchivesHelperGGC or {}
	ArchivesHelperGGC.Ans = nil
	
	function ArchivesHelperGGC:SetAns(__id, __them)
		if managers.worlddefinition and type(__them) == "table" and type(__id) == "number" and type(__them._values) == "table" and type(__them._values.trigger_list) == "table" then
			local __pick
			for __i, __d in pairs(__them._values.trigger_list) do
				if type(__d) == "table" and type(__d.notify_unit_sequence) == "string" and __d.notify_unit_sequence == "interaction_enable" then
					local __ans_unit = managers.worlddefinition:get_unit(__d.notify_unit_id)
					if type( __ans_unit ) == "userdata" then
						self.Ans = __ans_unit:position()
						log( type(self.Ans) )
					end
				end
			end
		end
		return
	end
	
	function ArchivesHelperGGC:WPON()
		managers.hud:add_waypoint(
			"kenaz_ArchivesHelperGGC", {
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
	
	function ArchivesHelperGGC:WPOFF()
		managers.hud:remove_waypoint("kenaz_ArchivesHelperGGC")
		return
	end
end