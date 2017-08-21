_G.LaterMyFriendMenu = _G.LaterMyFriendMenu or {}
LaterMyFriendMenu._path = ModPath
LaterMyFriendMenu._data_path = SavePath .. "LaterMyFriend.txt"

LaterMyFriendMenu._data = {
	_delay = 360,
	_times = 0,
	_users = {0}
}

function LaterMyFriendMenu:Save()
    local file = io.open(self._data_path, "w+")
    if file then
        file:write(json.encode(self._data))
        file:close()
    end
end

function LaterMyFriendMenu:Load()
    local file = io.open(self._data_path, "r")
    if file then
        self._data = json.decode(file:read("*all"))
        file:close()
	else
		self._data = {
			_delay = 360,
			_times = 0,
			_users = {0}
		}
		self:Save()
    end
end

Hooks:Add("LocalizationManagerPostInit", "LocalizationManagerPostInit_LaterMyFriendMenu", function(loc)
	loc:load_localization_file(LaterMyFriendMenu._path .. "en.txt")
end)

Hooks:Add("MenuManagerInitialize", "MenuManagerInitialize_LaterMyFriendMenu", function(menu_manager)
	MenuCallbackHandler.LaterMyFriendMenuSetDelay = function( this, item )
		LaterMyFriendMenu._data._delay = math.round(tonumber(item:value()))
		LaterMyFriendMenu:Save()
	end
	MenuCallbackHandler.LaterMyFriendMenuSetTimes = function( this, item )
		LaterMyFriendMenu._data._times = math.round(tonumber(item:value()))
		LaterMyFriendMenu:Save()
	end
    LaterMyFriendMenu:Load()
    MenuHelper:LoadFromJsonFile(LaterMyFriendMenu._path .. "menu_options.txt", LaterMyFriendMenu, LaterMyFriendMenu._data)
end)

LaterMyFriendMenu:Load()