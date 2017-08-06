_G.UselessHUD = _G.UselessHUD or {}
UselessHUD.options_menu = "UselessHUD_menu"
UselessHUD.ModPath = ModPath
UselessHUD.SaveFile = UselessHUD.SaveFile or SavePath .. "UselessHUD.txt"
UselessHUD.ModOptions = UselessHUD.ModPath .. "menus/modoptions.txt"
UselessHUD.settings = UselessHUD.settings or {}

function UselessHUD:Reset()
	self.settings = {
		Weather = 1,
		Stock = 1,
		Weather_Specify_Bool = 0,
		Weather_Specify_ID = "",
		Weather_Local_Bool = 0,
	}
	self:Save()
end

function UselessHUD:Load()
	local file = io.open(self.SaveFile, "r")
	if file then
		for key, value in pairs(json.decode(file:read("*all"))) do
			self.settings[key] = value
		end
		file:close()
	else
		self:Reset()
	end
end

function UselessHUD:Save()
	local file = io.open(self.SaveFile, "w+")
	if file then
		file:write(json.encode(self.settings))
		file:close()
	end
end

UselessHUD:Load()

Hooks:Add("LocalizationManagerPostInit", "UselessHUD_loc", function(loc)
	LocalizationManager:add_localized_strings({
		["UselessHUD_menu_title"] = "Useless HUD",
		["UselessHUD_menu_desc"] = "",
		["UselessHUD_menu_weather_bool_title"] = "Weather App",
		["UselessHUD_menu_weather_bool_desc"] = "Turn ON or OFF this function",
		["UselessHUD_menu_stock_bool_title"] = "Stock App",
		["UselessHUD_menu_stock_bool_desc"] = "Turn ON or OFF this function",
		["UselessHUD_menu_stock_list_update_title"] = "Update Stock List",
		["UselessHUD_menu_stock_list_update_desc"] = "",
		["UselessHUD_menu_weather_special_title"] = "Weather App - Specify",
		["UselessHUD_menu_weather_special_desc"] = "Turn ON or OFF to define City ID",
		["UselessHUD_menu_weather_local_title"] = "Weather App - Local",
		["UselessHUD_menu_weather_local_desc"] = "Turn ON or OFF to use your local",
		["UselessHUD_menu_unban_title"] = "UnBan IP (ip-api.com)",
		["UselessHUD_menu_unban_desc"] = "If you get ban on this site",
	})
end)

Hooks:Add("MenuManagerSetupCustomMenus", "UselessHUDOptions", function( menu_manager, nodes )
	MenuHelper:NewMenu( UselessHUD.options_menu )
end)

Hooks:Add("MenuManagerPopulateCustomMenus", "UselessHUDOptions", function( menu_manager, nodes )
	local _bool = false
	MenuCallbackHandler.UselessHUD_menu_stock_list_update_callback = function(self, item)
		local _dialog_data = {
			title = "Updating...",
			text = "",
			button_list = {{ text = "OK", is_cancel_button = true }},
			id = tostring(math.random(0,0xFFFFFFFF))
		}
		managers.system_menu:show(_dialog_data)
		dohttpreq("ftp://ftp.nasdaqtrader.com/symboldirectory/nasdaqlisted.txt", function(data)
			if data then
				local file = io.open("mods/Useless-HUD/Stock/stock_list.txt", "w")
				file:write(data)
				file:close()
				file = io.open("mods/Useless-HUD/Stock/stock_list.txt", "r")
				local line = file:read()
				local _txt = tostring(line)
				local _txt_split = mysplit(_txt, "|")
				local _lua_data = {}
				while line do
					table.insert(_lua_data, _txt_split[1])
					line = file:read()
					_txt = tostring(line)
					_txt_split = mysplit(_txt, "|")
				end
				file:close()
				file = io.open("mods/Useless-HUD/Stock/stock_list.txt", "w")
				_lua_data[#_lua_data] = ""
				_lua_data[1] = ""
				file:write(json.encode(_lua_data))
				file:close()
				local _dialog_data = {
					title = "Success!!",
					text = "",
					button_list = {{ text = "OK", is_cancel_button = true }},
					id = tostring(math.random(0,0xFFFFFFFF))
				}
				managers.system_menu:show(_dialog_data)
			end
		end)
	end
	MenuHelper:AddButton({
		id = "UselessHUD_menu_stock_list_update_callback",
		title = "UselessHUD_menu_stock_list_update_title",
		desc = "UselessHUD_menu_stock_list_update_desc",
		callback = "UselessHUD_menu_stock_list_update_callback",
		menu_id = UselessHUD.options_menu,
	})
	MenuCallbackHandler.UselessHUD_menu_stock_bool_callback = function(self, item)
		if tostring(item:value()) == "on" then
			UselessHUD.settings.Stock = 1
			DelayedCalls:Add("DelayedCalls_Uselesshud_Stock_ON", 1, function()
				if managers.hud and managers.hud._uselesshud_stock then
					managers.hud._uselesshud_stock:SetVisible(true)
					managers.hud._uselesshud_stock:GetData()
				end
			end)
		else
			UselessHUD.settings.Stock = 0
			DelayedCalls:Add("DelayedCalls_Uselesshud_Stock_OFF", 1, function()
				if managers.hud and managers.hud._uselesshud_stock then
					managers.hud._uselesshud_stock:SetVisible(false)
				end
			end)
		end
		UselessHUD:Save()
	end
	_bool = UselessHUD.settings.Stock == 1 and true or false
	MenuHelper:AddToggle({
		id = "UselessHUD_menu_stock_bool_callback",
		title = "UselessHUD_menu_stock_bool_title",
		desc = "UselessHUD_menu_stock_bool_desc",
		callback = "UselessHUD_menu_stock_bool_callback",
		value = _bool,
		menu_id = UselessHUD.options_menu,
	})
	
	MenuCallbackHandler.UselessHUD_menu_weather_bool_callback = function(self, item)
		if tostring(item:value()) == "on" then
			UselessHUD.settings.Weather = 1
			DelayedCalls:Add("DelayedCalls_Uselesshud_Weather_ON", 1, function()
				if managers.hud and managers.hud._uselesshud_weather then
					managers.hud._uselesshud_weather:SetVisible(true)
					managers.hud._uselesshud_weather:GetData()
				end
			end)
		else
			UselessHUD.settings.Weather = 0
			DelayedCalls:Add("DelayedCalls_Uselesshud_Weather_OFF", 1, function()
				if managers.hud and managers.hud._uselesshud_weather then
					managers.hud._uselesshud_weather:SetVisible(false)
				end
			end)
		end
		UselessHUD:Save()
	end
	_bool = UselessHUD.settings.Weather == 1 and true or false
	MenuHelper:AddToggle({
		id = "UselessHUD_menu_weather_bool_callback",
		title = "UselessHUD_menu_weather_bool_title",
		desc = "UselessHUD_menu_weather_bool_desc",
		callback = "UselessHUD_menu_weather_bool_callback",
		value = _bool,
		menu_id = UselessHUD.options_menu,
	})
	MenuCallbackHandler.UselessHUD_menu_weather_special_callback = function(self, item)
		if tostring(item:value()) == "on" then
			UselessHUD:Weather_Specify_Main()
		else
			UselessHUD.settings.Weather_Specify_Bool = 0
		end
		UselessHUD:Save()
	end
	_bool = UselessHUD.settings.Weather_Specify_Bool == 1 and true or false
	MenuHelper:AddToggle({
		id = "UselessHUD_menu_weather_special_callback",
		title = "UselessHUD_menu_weather_special_title",
		desc = "UselessHUD_menu_weather_special_desc",
		callback = "UselessHUD_menu_weather_special_callback",
		value = _bool,
		menu_id = UselessHUD.options_menu,
	})
	MenuCallbackHandler.UselessHUD_menu_weather_local_callback = function(self, item)
		if tostring(item:value()) == "on" then
			UselessHUD.settings.Weather_Local_Bool = 1
			UselessHUD.settings.Weather_Specify_Bool = 0
		else
			UselessHUD.settings.Weather_Local_Bool = 0
		end
		UselessHUD:Save()
	end
	_bool = UselessHUD.settings.Weather_Local_Bool == 1 and true or false
	MenuHelper:AddToggle({
		id = "UselessHUD_menu_weather_local_callback",
		title = "UselessHUD_menu_weather_local_title",
		desc = "UselessHUD_menu_weather_local_desc",
		callback = "UselessHUD_menu_weather_local_callback",
		value = _bool,
		menu_id = UselessHUD.options_menu,
	})
	MenuCallbackHandler.UselessHUD_menu_unban_callback = function(self, item)		
		Steam:overlay_activate("url", "http://ip-api.com/docs/unban")
	end
	MenuHelper:AddButton({
		id = "UselessHUD_menu_unban_callback",
		title = "UselessHUD_menu_unban_title",
		desc = "UselessHUD_menu_unban_desc",
		callback = "UselessHUD_menu_unban_callback",
		menu_id = UselessHUD.options_menu,
	})
end)

function UselessHUD:Weather_Specify_Main()
	local opts = {}
	local _city = ""
	opts[#opts+1] = { text = "Search", callback_func = callback(self, self, "Menu_UselessHUD_Weather_Specify_Search", {}) }
	opts[#opts+1] = { text = "Change", callback_func = callback(self, self, "Menu_UselessHUD_Weather_Specify_Change", {id = ""}) }
	opts[#opts+1] = { text = "[Cancel]", is_cancel_button = true }
	if not UselessHUD.settings.Weather_Specify_ID then
		_city = "~ No Defiend ~"
	else
		_city = "Current: " .. UselessHUD.settings.Weather_Specify_ID
	end
	local _dialog_data = {
		title = "" .. _city,
		text = "",
		button_list = opts,
		id = tostring(math.random(0,0xFFFFFFFF))
	}
	if managers.system_menu then
		managers.system_menu:show(_dialog_data)
	end
end

function UselessHUD:Menu_UselessHUD_Weather_Specify_Change(data)
	local opts = {}
	local _city = ""
	for i = 0, 9 do
		opts[#opts+1] = { text = "" .. i, callback_func = callback(self, self, "Menu_UselessHUD_Weather_Specify_Change", {id = data.id .. "" .. i}) }
	
	end
	opts[#opts+1] = { text = "[OK]", callback_func = callback(self, self, "Menu_UselessHUD_Weather_Specify_Change_OK", {id = data.id}) }
	opts[#opts+1] = { text = "[Cancel]", callback_func = callback(self, self, "Weather_Specify_Main", {}) }
	if not data then
		_city = "Current: -No Defiend-"
	else
		_city = "Current: " .. data.id
	end
	local _dialog_data = {
		title = "" .. _city,
		text = "",
		button_list = opts,
		id = tostring(math.random(0,0xFFFFFFFF))
	}
	if managers.system_menu then
		managers.system_menu:show(_dialog_data)
	end
end

function UselessHUD:Menu_UselessHUD_Weather_Specify_Change_OK(data)
	UselessHUD.settings.Weather_Specify_ID = data and data.id or ""
	UselessHUD.settings.Weather_Specify_Bool = 1
	UselessHUD.settings.Weather_Local_Bool = 0
	UselessHUD:Save()
	managers.hud._uselesshud_weather:SetVisible(true)
	managers.hud._uselesshud_weather:GetData()
	UselessHUD:Weather_Specify_Main()
end

function UselessHUD:Menu_UselessHUD_Weather_Specify_Search()
	Steam:overlay_activate("url", "http://openweathermap.org/find")
	UselessHUD:Weather_Specify_Main()
end

Hooks:Add("MenuManagerBuildCustomMenus", "UselessHUDOptions", function(menu_manager, nodes)
	nodes[UselessHUD.options_menu] = MenuHelper:BuildMenu( UselessHUD.options_menu )
	MenuHelper:AddMenuItem( MenuHelper.menus.lua_mod_options_menu, UselessHUD.options_menu, "UselessHUD_menu_title", "UselessHUD_menu_desc", 1 )
end)

function mysplit(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t={} ; i=1
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
		t[i] = str
		i = i + 1
	end
	return t
end