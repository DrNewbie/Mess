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

function MenuCallbackHandler:accept_skirmish_contract(item, node)
	managers.menu:active_menu().logic:navigate_back(true)
	managers.menu:active_menu().logic:navigate_back(true)
	local job_data = {
		difficulty = "overkill_145",
		job_id = managers.skirmish:random_skirmish_job_id()
	}	
	if CHOD.settings.CHOD_slider_value == 2 then
		job_data.difficulty = "easy_wish"
	elseif CHOD.settings.CHOD_slider_value == 3 then
		job_data.difficulty = "overkill_290"
	elseif CHOD.settings.CHOD_slider_value == 4 then
		job_data.difficulty = "sm_wish"
	end
	if Global.game_settings.single_player then
		MenuCallbackHandler:start_single_player_job(job_data)
	else
		MenuCallbackHandler:start_job(job_data)
	end
end

function MenuCallbackHandler:accept_skirmish_weekly_contract(item, node)
	managers.menu:active_menu().logic:navigate_back(true)
	managers.menu:active_menu().logic:navigate_back(true)
	local weekly_skirmish = managers.skirmish:active_weekly()
	local job_data = {
		difficulty = "overkill_145",
		weekly_skirmish = true,
		job_id = weekly_skirmish.id
	}
	if CHOD.settings.CHOD_slider_value == 2 then
		job_data.difficulty = "easy_wish"
	elseif CHOD.settings.CHOD_slider_value == 3 then
		job_data.difficulty = "overkill_290"
	elseif CHOD.settings.CHOD_slider_value == 4 then
		job_data.difficulty = "sm_wish"
	end
	if Global.game_settings.single_player then
		MenuCallbackHandler:start_single_player_job(job_data)
	else
		MenuCallbackHandler:start_job(job_data)
	end
end