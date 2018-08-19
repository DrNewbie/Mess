_G.EODaS = _G.EODaS or {}
EODaS._path = ModPath
EODaS._data_path = SavePath .. "EODaS_options.txt"
EODaS.settings = {}

function EODaS:Save()
	local file = io.open( self._data_path, "w" )
	if file then
		file:write( json.encode( self.settings ) )
		file:close()
	end
end

function EODaS:Load()
	local file = io.open( self._data_path, "r" )
	if file then
		self.settings = json.decode( file:read("*all") )
		file:close()
	end
end

EODaS:Load()

Hooks:Add("LocalizationManagerPostInit", "LocalizationManagerPostInit_EODaS", function( loc )
	loc:load_localization_file(EODaS._path .. "loc/english.txt", false)
end)

Hooks:Add( "MenuManagerInitialize", "MenuManagerInitialize_EODaS", function( menu_manager )
	MenuCallbackHandler.EODaS_toggle = function(self, item)
		EODaS.settings.EODaS_toggle_value = tostring(item:value()) == "on" and true or false
		EODaS:Save()
	end
	MenuCallbackHandler.EODaSSave = function()
		EODaS:Save()
	end
	EODaS:Load()
	MenuHelper:LoadFromJsonFile( EODaS._path .. "menu/options.txt", EODaS, EODaS.settings )
end )


function EODaS:ResetToDefaultValues()
	EODaS.settings.EODaS_toggle_value = false
end

if EODaS.settings.EODaS_toggle_value == nil then
	self:ResetToDefaultValues()
end

function EODaS:Apply(them)
	if Global.game_settings.level_id and tostring(tweak_data.levels[Global.game_settings.level_id].group_ai_state) == "skirmish" then
		Global.game_settings.one_down = self.settings.EODaS_toggle_value and true or false
		local matchmake_attributes = them:get_matchmake_attributes()
		local job_id_index = tweak_data.narrative:get_index_from_job_id(managers.job:current_job_id())
		local level_id_index = tweak_data.levels:get_index_from_level_id(Global.game_settings.level_id)
		local difficulty_index = tweak_data:difficulty_to_index(Global.game_settings.difficulty)
		local one_down = Global.game_settings.one_down
		managers.network:session():send_to_peers("sync_game_settings", job_id_index, level_id_index, difficulty_index, one_down)
		managers.network.matchmake:set_server_attributes(matchmake_attributes)
		managers.mutators:update_lobby_info()
		managers.menu_component:on_job_updated()
		managers.menu:open_node("lobby")
		managers.menu:active_menu().logic:refresh_node("lobby", true)
	end
end

Hooks:PostHook(MenuCallbackHandler, "accept_skirmish_contract", Idstring("EODaS.accept_skirmish_contract"):key(), function(self)
	EODaS:Apply(self)
end)

Hooks:PostHook(MenuCallbackHandler, "accept_skirmish_weekly_contract", Idstring("EODaS.accept_skirmish_contract"):key(), function(self)
	EODaS:Apply(self)
end)