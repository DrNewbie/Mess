local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

Hooks:Add('LocalizationManagerPostInit', 'LocalizationManagerPostInit_LobbyPlayerInfo', function(loc)
	local language_filename

	if BLT.Localization._current == 'cht' or BLT.Localization._current == 'zh-cn' then
		LobbyPlayerInfo._abbreviation_length_v = 2
		language_filename = 'chinese.txt'
	end

	if not language_filename then
		local modname_to_language = {
			['Payday 2 Korean patch'] = 'korean.txt',
			['PAYDAY 2 THAI LANGUAGE Mod'] = 'thai.txt',
		}
		for _, mod in pairs(BLT and BLT.Mods:Mods() or {}) do
			language_filename = mod:IsEnabled() and modname_to_language[mod:GetName()]
			if language_filename then
				LobbyPlayerInfo._abbreviation_length_v = 2
				break
			end
		end
	end

	if not language_filename then
		for _, filename in pairs(file.GetFiles(LobbyPlayerInfo._path .. 'loc/')) do
			local str = filename:match('^(.*).txt$')
			if str and Idstring(str) and Idstring(str):key() == SystemInfo:language():key() then
				language_filename = filename
				break
			end
		end
	end

	if language_filename then
		loc:load_localization_file(LobbyPlayerInfo._path .. 'loc/' .. language_filename)
	end
	loc:load_localization_file(LobbyPlayerInfo._path .. 'loc/english.txt', false)
end)

Hooks:Add('MenuManagerInitialize', 'MenuManagerInitialize_LobbyPlayerInfo', function(menu_manager)

	MenuCallbackHandler.LobbyPlayerInfoShowPerkDeckMode = function(this, item)
		LobbyPlayerInfo.settings.show_perkdeck_mode = item:value()
	end

	MenuCallbackHandler.LobbyPlayerInfoShowPerkDeckProgression = function(this, item)
		LobbyPlayerInfo.settings.show_perkdeck_progression = item:value() == 'on' and true or false
	end

	MenuCallbackHandler.LobbyPlayerInfoHideCompletePerkDeckProgression = function(this, item)
		LobbyPlayerInfo.settings.hide_complete_perkdeck_progression = item:value() == 'on' and true or false
	end

	MenuCallbackHandler.LobbyPlayerInfoShowPerkdeckProgressionGraphically = function(this, item)
		LobbyPlayerInfo.settings.show_perkdeck_progression_graphically = item:value() == 'on' and true or false
	end

	MenuCallbackHandler.LobbyPlayerInfoShowPerkDeckInLoadout = function(this, item)
		LobbyPlayerInfo.settings.show_perkdeck_in_loadout = item:value() == 'on' and true or false
	end

	MenuCallbackHandler.LobbyPlayerInfoTeamSkillsMode = function(this, item)
		LobbyPlayerInfo.settings.team_skills_mode = item:value()
		if managers.menu_component._contract_gui then
			LPITeamBox:Update()
		end
	end

	MenuCallbackHandler.LobbyPlayerInfoShowSkillsMode = function(this, item)
		LobbyPlayerInfo.settings.show_skills_mode = item:value()
	end

	MenuCallbackHandler.LobbyPlayerInfoSetLayout = function(self, item)
		LobbyPlayerInfo.settings.skills_layout = item:value()
		local contract_gui = managers.menu_component._contract_gui
		if contract_gui then
			if contract_gui._peers_skills then
				for _, obj in pairs(contract_gui._peers_skills) do
					obj:parent():remove(obj)
				end
				contract_gui._peers_skills = {}
			else
				for peer_id, chardata in pairs(contract_gui._peer_panels) do
					if chardata._peer_skills then
						chardata._peer_skills:parent():remove(chardata._peer_skills)
						chardata._peer_skills = LobbyPlayerInfo:CreatePeerSkills(chardata._panel)
					end
				end
			end
		end
	end

	MenuCallbackHandler.LobbyPlayerInfoSetFontSizeForSkills = function(self, item)
		LobbyPlayerInfo.settings.skills_font_size = item:value()
	end

	MenuCallbackHandler.LobbyPlayerInfoSetDetailsForSkills = function(self, item)
		LobbyPlayerInfo.settings.skills_details = item:value()
	end

	MenuCallbackHandler.LobbyPlayerInfoShowPlayTime = function(this, item)
		LobbyPlayerInfo.settings.show_play_time_mode = item:value()
	end

	MenuCallbackHandler.LobbyPlayerInfoSetFontSizeForPlayTime = function(self, item)
		LobbyPlayerInfo.settings.play_time_font_size = item:value()
	end

	MenuCallbackHandler.LobbyPlayerInfoKeepPre68CharacterNamePosition = function(self, item)
		LobbyPlayerInfo.settings.keep_pre68_character_name_position = item:value() == 'on' and true or false
	end

	MenuCallbackHandler.LobbyPlayerInfoShowSkillsInStatsScreen = function(self, item)
		LobbyPlayerInfo.settings.show_skills_in_stats_screen = item:value() == 'on' and true or false
	end

	MenuCallbackHandler.LobbyPlayerInfoResetToDefaultValues = function(this, item)
		LobbyPlayerInfo:ResetToDefaultValues()
		MenuHelper:ResetItemsToDefaultValue(item, {['lpi_multi_show_perkdeck_mode'] = true}, LobbyPlayerInfo.settings.show_perkdeck_mode)
		MenuHelper:ResetItemsToDefaultValue(item, {['lpi_toggle_show_perkdeck_progression'] = true}, LobbyPlayerInfo.settings.show_perkdeck_progression)
		MenuHelper:ResetItemsToDefaultValue(item, {['lpi_toggle_hide_complete_perkdeck_progression'] = true}, LobbyPlayerInfo.settings.hide_complete_perkdeck_progression)
		MenuHelper:ResetItemsToDefaultValue(item, {['lpi_toggle_show_perkdeck_progression_graphically'] = true}, LobbyPlayerInfo.settings.show_perkdeck_progression_graphically)
		MenuHelper:ResetItemsToDefaultValue(item, {['lpi_toggle_show_perkdeck_in_loadout'] = true}, LobbyPlayerInfo.settings.show_perkdeck_in_loadout)
		MenuHelper:ResetItemsToDefaultValue(item, {['lpi_multi_team_skills_mode'] = true}, LobbyPlayerInfo.settings.team_skills_mode)
		MenuHelper:ResetItemsToDefaultValue(item, {['lpi_multi_show_skills_mode'] = true}, LobbyPlayerInfo.settings.show_skills_mode)
		MenuHelper:ResetItemsToDefaultValue(item, {['lpi_multi_skills_layout'] = true}, LobbyPlayerInfo.settings.skills_layout)
		MenuHelper:ResetItemsToDefaultValue(item, {['lpi_multi_skills_font_size'] = true}, LobbyPlayerInfo.settings.skills_font_size)
		MenuHelper:ResetItemsToDefaultValue(item, {['lpi_multi_skills_details'] = true}, LobbyPlayerInfo.settings.skills_details)
		MenuHelper:ResetItemsToDefaultValue(item, {['lpi_multi_show_play_time'] = true}, LobbyPlayerInfo.settings.show_play_time_mode)
		MenuHelper:ResetItemsToDefaultValue(item, {['lpi_multi_play_time_font_size'] = true}, LobbyPlayerInfo.settings.play_time_font_size)
		MenuHelper:ResetItemsToDefaultValue(item, {['lpi_toggle_keep_pre68_character_name_position'] = true}, LobbyPlayerInfo.settings.keep_pre68_character_name_position)
		MenuHelper:ResetItemsToDefaultValue(item, {['lpi_toggle_show_skills_in_stats_screen'] = true}, LobbyPlayerInfo.settings.show_skills_in_stats_screen)
	end

	MenuCallbackHandler.LobbyPlayerInfoSave = function(this, item)
		LobbyPlayerInfo:Save()
	end

	LobbyPlayerInfo:Load()

	MenuHelper:LoadFromJsonFile(LobbyPlayerInfo._path .. 'menu/options.txt', LobbyPlayerInfo, LobbyPlayerInfo.settings)

end)

local lpi_original_menumanager_pushtotalk = MenuManager.push_to_talk
function MenuManager:push_to_talk(enabled)
	lpi_original_menumanager_pushtotalk(self, enabled)
	if managers.network and managers.network.voice_chat and managers.network.voice_chat._enabled and managers.network:session() then
		managers.network.voice_chat._users_talking[managers.network:session():local_peer():id()] = { active = enabled }
	end
end
