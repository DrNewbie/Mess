Hooks:PostHook(HUDMissionBriefing, "init", "RVD_Days_Icon", function(self)
	if managers.job:current_job_data().name_id ~= "heist_rvd" then
		if managers.job:current_job_data().chain[1] then
			local day_1_text = self._job_schedule_panel:child("day_1")
			local day_1_sticker = self._job_schedule_panel:bitmap({
				texture = "guis/dlcs/rvd/textures/pd2/mission_briefing/day1",
				h = 48,
				w = 96,
				rotation = 360,
				layer = 2
			})

			day_1_sticker:set_center(day_1_text:center())
			day_1_sticker:move(math.random(4) - 2, math.random(4) - 2)
		end
		if managers.job:current_job_data().chain[2] then
			local day_2_text = self._job_schedule_panel:child("day_2")
			local day_2_sticker = self._job_schedule_panel:bitmap({
				texture = "guis/dlcs/rvd/textures/pd2/mission_briefing/day2",
				h = 48,
				w = 96,
				rotation = 360,
				layer = 2
			})
			day_2_sticker:set_center(day_2_text:center())
			day_2_sticker:move(math.random(4) - 2, math.random(4) - 2)
		end
	end
end )