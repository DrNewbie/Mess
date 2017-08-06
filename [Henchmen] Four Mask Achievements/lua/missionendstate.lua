_G.FourMaskAchievements = _G.FourMaskAchievements or {}
FourMaskAchievements.Mask = FourMaskAchievements.Mask or {}

Hooks:PostHook(MissionEndState, "chk_complete_heist_achievements", "crew_4maskach_get_achievements", function(self)
	if not self._success then
		return
	end
	for achievement,achievement_data in pairs(tweak_data.achievement.four_mask_achievements) do
		local crew_4maskach_pass = 0
		local masks_pass, level_pass, job_pass, jobs_pass, difficulty_pass, difficulties_pass, all_pass, memory, level_id, stage = nil, nil, nil, nil, nil, nil, nil, nil, nil, nil
		level_id = managers.job:has_active_job() and managers.job:current_level_id() or ""
		masks_pass = not not achievement_data.masks
		level_pass = not achievement_data.level_id or achievement_data.level_id == level_id
		job_pass = not achievement_data.job or not managers.statistics:started_session_from_beginning() or not managers.job:on_last_stage() or managers.job:current_real_job_id() == achievement_data.job
		if achievement_data.jobs and managers.statistics:started_session_from_beginning() and managers.job:on_last_stage() then
			jobs_pass = table.contains(achievement_data.jobs, managers.job:current_real_job_id())
		end
		jobs_pass = jobs_pass
		difficulty_pass = not achievement_data.difficulty or Global.game_settings.difficulty == achievement_data.difficulty
		if achievement_data.difficulties then
			difficulties_pass = table.contains(achievement_data.difficulties, Global.game_settings.difficulty)
			difficulties_pass = difficulties_pass
			all_pass = not masks_pass or not level_pass or not job_pass or not jobs_pass or not difficulty_pass or difficulties_pass
			if all_pass then
				local available_masks = deep_clone(achievement_data.masks)
				local all_masks_valid = true
				local valid_mask_count = 0
				for _,peer in pairs(managers.network:session():all_peers()) do
					local current_mask = peer:mask_id()
					if table.contains(available_masks, current_mask) then
						table.delete(available_masks, current_mask)
						valid_mask_count = valid_mask_count + 1
					end
				end
				for u_key, u_data in pairs(managers.groupai:state():all_char_criminals()) do
					if u_data and u_data.unit and alive(u_data.unit) then
						local current_mask = FourMaskAchievements.Mask[u_data.unit:name():key()] or ''
						if table.contains(available_masks, current_mask) then
							table.delete(available_masks, current_mask)
							valid_mask_count = valid_mask_count + 1
						end
					end
				end
				for i = 1, 3 do
					local _name = 'crew_4maskach_' .. i
					if managers.player:has_category_upgrade("team", _name) then
						crew_4maskach_pass = crew_4maskach_pass + 1
					end
				end
				all_masks_valid = valid_mask_count == 4
				if crew_4maskach_pass == 3 then
					if all_masks_valid then
						if achievement_data.stat then
							managers.achievment:award_progress(achievement_data.stat)
						elseif achievement_data.award then
							managers.achievment:award(achievement_data.award)
						elseif achievement_data.challenge_stat then
							managers.challenge:award_progress(achievement_data.challenge_stat)
						elseif achievement_data.trophy_stat then
							managers.custom_safehouse:award(achievement_data.trophy_stat)
						elseif achievement_data.challenge_award then
							managers.challenge:award(achievement_data.challenge_award)
						end
					end
				end
			end
		end
	end
	managers.achievment:clear_heist_success_awards()
end)