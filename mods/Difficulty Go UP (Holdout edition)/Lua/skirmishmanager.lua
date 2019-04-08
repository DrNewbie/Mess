Hooks:PreHook(SkirmishManager, "on_end_assault", "SkirmishMod_IncreaseDifficulty", function(self)
	local wave_number = self:current_wave_number() + 1
	local difficulty = {
		"hard",
		"hard",
		"overkill",
		"overkill_145",
		"overkill_145",
		"easy_wish",
		"easy_wish",
		"overkill_290",
		"overkill_290"
	}
	if difficulty[wave_number] then
		local duff = difficulty[wave_number]
		local job_id_index = tweak_data.narrative:get_index_from_job_id(managers.job:current_job_id())
		local level_id_index = tweak_data.levels:get_index_from_level_id(Global.game_settings.level_id)
		local difficulty_index = tweak_data:difficulty_to_index(duff)
		local one_down = Global.game_settings.one_down and true or false		
		Global.game_settings.difficulty = duff
		tweak_data:set_difficulty(duff)
		if managers.network then
			managers.network:session():send_to_peers("sync_game_settings", job_id_index, level_id_index, difficulty_index, one_down)
		end
	end
end)