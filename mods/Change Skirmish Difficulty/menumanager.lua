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
	self.settings.CHOD_slider_value = 1
end

if CHOD.settings.CHOD_slider_value == nil then
	self:ResetToDefaultValues()
end

function CHOD:Apply()
	if type(SkirmishManager) == "table" and SkirmishManager:is_skirmish() and Global.game_settings and Global.game_settings.difficulty then
		if self.settings.CHOD_slider_value == 2 then
			Global.game_settings.difficulty = "easy_wish"
		elseif self.settings.CHOD_slider_value == 3 then
			Global.game_settings.difficulty = "overkill_290"
		elseif self.settings.CHOD_slider_value == 4 then
			Global.game_settings.difficulty = "sm_wish"
		elseif self.settings.CHOD_slider_value == 1 then
			Global.game_settings.difficulty = "overkill_145"
		end
	end
end