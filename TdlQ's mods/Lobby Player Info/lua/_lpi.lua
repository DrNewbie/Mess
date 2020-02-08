_G.LobbyPlayerInfo = _G.LobbyPlayerInfo or {}
LobbyPlayerInfo._path = ModPath
LobbyPlayerInfo._data_path = SavePath .. 'lobby_player_info.txt'
LobbyPlayerInfo._font_sizes = {
	tweak_data.menu.pd2_small_font_size - 6,
	tweak_data.menu.pd2_small_font_size - 4,
	tweak_data.menu.pd2_small_font_size - 2,
	tweak_data.menu.pd2_small_font_size - 0,
}
LobbyPlayerInfo.settings = {}
LobbyPlayerInfo.play_times = Global.lpi_play_times or {}
Global.lpi_play_times = LobbyPlayerInfo.play_times
LobbyPlayerInfo.pd2stats_player_status = {}
LobbyPlayerInfo.skills_layouts = {
	'%s:%02u  %s:%02u  %s:%02u  %s:%02u  %s:%02u',
	'%s.: %s\n%s.: %s\n%s.: %s\n%s.: %s\n%s.: %s',
	'',
	'%s:%02u %02u %02u  %s:%02u %02u %02u  %s:%02u %02u %02u  %s:%02u %02u %02u  %s:%02u %02u %02u' -- for hudstatsscreen
}
LobbyPlayerInfo._abbreviation_length_v = 3

function LobbyPlayerInfo:ResetToDefaultValues()
	self.settings = {
		team_skillpoints_thresholds = {
			silver = 25,
			gold = 40,
			overspecialized = 80
		},
		show_perkdeck_mode = 3,
		show_perkdeck_progression = true,
		hide_complete_perkdeck_progression = true,
		show_perkdeck_progression_graphically = true,
		show_perkdeck_in_loadout = true,
		show_skills_mode = 2,
		skills_layout = 2,
		skills_font_size = 3,
		skills_details = 2,
		show_play_time_mode = 1,
		play_time_font_size = 1,
		team_skills_mode = 4,
		keep_pre68_character_name_position = false,
		show_skills_in_stats_screen = true,
		steam_apikey = 'get one at https://steamcommunity.com/dev/apikey', -- and write it in mods/saves/lobby_player_info.txt
	}
end

function LobbyPlayerInfo:GetPerkTextId(perk_id)
	if perk_id and tonumber(perk_id) <= #tweak_data.skilltree.specializations then
		return 'st_spec_' .. tostring(perk_id)
	else
		return 'lpi_fake_deck'
	end
end

function LobbyPlayerInfo:GetPerkText(perk_id)
	return managers.localization:text('menu_' .. self:GetPerkTextId(perk_id))
end

function LobbyPlayerInfo:GetFontSizeForSkills()
	return self._font_sizes[self.settings.skills_font_size or 2]
end

function LobbyPlayerInfo:GetFontSizeForPlayTime()
	return self._font_sizes[self.settings.play_time_font_size or 1]
end

function LobbyPlayerInfo:GetSkillsFormat()
	return self.skills_layouts[self.settings.skills_layout]
end

function LobbyPlayerInfo:GetSkillNameLength()
	if self.settings.skills_layout == 1 then
		return 1
	else
		return self._abbreviation_length_v
	end
end

function LobbyPlayerInfo:GetSkillPointsPerTree(skills)
	local result = {}
	for i = 0, 4 do
		result[i+1] = skills[i * 3 + 1] + skills[i * 3 + 2] + skills[i * 3 + 3]
	end
	return result
end

function LobbyPlayerInfo:Load()
	self:ResetToDefaultValues()
	local file = io.open(self._data_path, 'r')
	if file then
		for k, v in pairs(json.decode(file:read('*all')) or {}) do
			self.settings[k] = v
		end
		file:close()
	end
end

function LobbyPlayerInfo:Save()
	local file = io.open(self._data_path, 'w+')
	if file then
		file:write(json.encode(self.settings))
		file:close()
	end
end
