_G.CHOD = _G.CHOD or {}
CHOD._path = ModPath
CHOD._data_path = SavePath .. "CHOD_options.txt"
CHOD.settings = {}

function CHOD:Save()
	local file = io.open( self._data_path, "w" )
	if file then
		file:write( json.encode( self.settings ) )
		file:close()
	end
end

function CHOD:Load()
	local file = io.open( self._data_path, "r" )
	if file then
		self.settings = json.decode( file:read("*all") )
		file:close()
	end
end

CHOD:Load()

Hooks:Add("LocalizationManagerPostInit", "LocalizationManagerPostInit_CHOD", function( loc )
	loc:load_localization_file(CHOD._path .. "loc/english.txt", false)
end)

Hooks:Add( "MenuManagerInitialize", "MenuManagerInitialize_CHOD", function( menu_manager )
	MenuCallbackHandler.CHOD_slider = function(self, item)
		CHOD.settings.CHOD_slider_value = item:value() or 1
		CHOD:Save()
	end
	CHOD:Load()
	MenuHelper:LoadFromJsonFile( CHOD._path .. "menu/options.txt", CHOD, CHOD.settings )
end )


function CHOD:ResetToDefaultValues()
	CHOD.settings.CHOD_slider_value = 1
end

if CHOD.settings.CHOD_slider_value == nil then
	self:ResetToDefaultValues()
end

function CHOD:Apply(them)
	if self.settings.CHOD_slider_value == 2 then
		Global.game_settings.difficulty = "easy_wish"
	elseif self.settings.CHOD_slider_value == 3 then
		Global.game_settings.difficulty = "overkill_290"
	elseif self.settings.CHOD_slider_value == 4 then
		Global.game_settings.difficulty = "sm_wish"
	elseif self.settings.CHOD_slider_value == 1 then
		Global.game_settings.difficulty = "overkill_145"
	end
	local matchmake_attributes = them:get_matchmake_attributes()
	if Network:is_server() then
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
	else
		managers.network.matchmake:create_lobby(matchmake_attributes)
	end
end

Hooks:PostHook(MenuCallbackHandler, "accept_skirmish_contract", Idstring("CHOD.accept_skirmish_contract"):key(), function(self)
	CHOD:Apply(self)
end)

Hooks:PostHook(MenuCallbackHandler, "accept_skirmish_weekly_contract", Idstring("CHOD.accept_skirmish_contract"):key(), function(self)
	CHOD:Apply(self)
end)