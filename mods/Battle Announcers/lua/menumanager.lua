local ThisModPath = tostring(ModPath)
local ThisModIds = Idstring(ThisModPath):key()
local ThisModFilesPath = ThisModPath.."/files/"
local __Name = function(__id)
	return "K_"..Idstring(tostring(__id).."::"..ThisModIds):key()
end

if _G[__Name(301)] then return end
_G[__Name(301)] = true

local ThisModData = __Name(302)
_G[ThisModData] = _G[ThisModData] or {}

local function __Save()
	io.save_as_json(_G[ThisModData], ThisModPath.."__savefile.txt")
	return
end

local function __Load()
	_G[ThisModData] = io.load_as_json(ThisModPath.."__savefile.txt")
	if type(_G[ThisModData]) ~= "table" then
		_G[ThisModData] = {true}
	end
	__Save()
	return
end

__Load()

local ThisModMenuID = __Name("menu_id")

Hooks:Add("MenuManagerSetupCustomMenus", __Name("MenuManagerSetupCustomMenus"), function()
	MenuHelper:NewMenu(ThisModMenuID)
end)

Hooks:Add("MenuManagerBuildCustomMenus", __Name("MenuManagerBuildCustomMenus"), function(menu_manager, nodes)
	nodes[ThisModMenuID] = MenuHelper:BuildMenu(ThisModMenuID)
	MenuHelper:AddMenuItem(nodes["blt_options"], ThisModMenuID, "battle_announcers_menu_title", "battle_announcers_menu_desc")
	managers.localization:add_localized_strings({
		["battle_announcers_menu_title"] = "Battle Announcers",
		["battle_announcers_menu_desc"] = " ",
		["battle_announcers_popup_position_x"] = "POP-UP POSITION - X",
		["battle_announcers_popup_position_y"] = "POP-UP POSITION - Y",
	})
end)

Hooks:Add("MenuManagerPopulateCustomMenus", __Name("MenuManagerPopulateCustomMenus"), function(menu_manager, nodes)
	_G[ThisModData] = _G[ThisModData] or {}
	local __sub_folder = file.GetDirectories(ThisModFilesPath)
	for _, folder_name in pairs(__sub_folder) do
		local full_path = ThisModFilesPath.."/"..folder_name
		local cfg_path = full_path.."/config.txt"
		if io.file_is_readable(cfg_path) then
			local __this_package_title_id = __Name(folder_name.."::title_id")
			local __this_package_desc_id = __Name(folder_name.."::desc_id")
			local __this_package_callback = __Name(folder_name.."::callback")
			local __this_package_main_volume = __Name(folder_name.."::main_volume")
			local __sub_folder = file.GetDirectories(ThisModFilesPath)
			managers.localization:add_localized_strings({
				[__this_package_title_id] = folder_name,
				[__this_package_desc_id] = full_path
			})
			if type(_G[ThisModData][__this_package_main_volume]) ~= "number" then
				_G[ThisModData][__this_package_main_volume] = 50
			end
			_G[ThisModData][__this_package_main_volume] = math.clamp(_G[ThisModData][__this_package_main_volume], 0, 100)
			MenuCallbackHandler[__this_package_callback] = function(self, item)
				_G[ThisModData] = _G[ThisModData] or {}
				_G[ThisModData][__this_package_main_volume] = math.clamp(math.floor(item:value()), 0, 100)
				DelayedCalls:Add(__Name("this_package_callback_delay_save"), 1, function()
					__Save()
				end)
			end
			MenuHelper:AddSlider({
			  id = __Name(cfg_path),
			  title = __this_package_title_id,
			  desc = __this_package_desc_id,
			  callback = __this_package_callback,
			  value = _G[ThisModData][__this_package_main_volume],
			  min = 0,
			  max = 100,
			  step = 1,
			  show_value = true,
			  menu_id = ThisModMenuID
			})
		end
	end
	local __popup_position_x = __Name("battle_announcers_popup_position_x")
	local __popup_position_x_callback = __Name(__popup_position_x.."::callback")
	local __popup_position_y = __Name("battle_announcers_popup_position_y")
	local __popup_position_y_callback = __Name(__popup_position_y.."::callback")
	if type(_G[ThisModData][__popup_position_x]) ~= "number" then
		_G[ThisModData][__popup_position_x] = 200
	end
	if type(_G[ThisModData][__popup_position_y]) ~= "number" then
		_G[ThisModData][__popup_position_y] = 80
	end
	MenuCallbackHandler[__popup_position_x_callback] = function(self, item)
		_G[ThisModData] = _G[ThisModData] or {}
		_G[ThisModData][__popup_position_x] = math.clamp(math.floor(item:value()), 0, 10000)
		DelayedCalls:Add(__Name("popup_position_x_callback_delay_save"), 1, function()
			__Save()
		end)
	end
	MenuHelper:AddSlider({
		id = __popup_position_x,
		title = "battle_announcers_popup_position_x",
		desc = "battle_announcers_menu_desc",
		callback = __popup_position_x_callback,
		value = _G[ThisModData][__popup_position_x],
		min = 0,
		max = 10000,
		step = 1,
		show_value = true,
		menu_id = ThisModMenuID,
		priority = 1000
	})
	MenuCallbackHandler[__popup_position_y_callback] = function(self, item)
		_G[ThisModData] = _G[ThisModData] or {}
		_G[ThisModData][__popup_position_y] = math.clamp(math.floor(item:value()), 0, 10000)
		DelayedCalls:Add(__Name("popup_position_y_callback_delay_save"), 1, function()
			__Save()
		end)
	end
	MenuHelper:AddSlider({
		id = __popup_position_y,
		title = "battle_announcers_popup_position_y",
		desc = "battle_announcers_menu_desc",
		callback = __popup_position_y_callback,
		value = _G[ThisModData][__popup_position_y],
		min = 0,
		max = 10000,
		step = 1,
		show_value = true,
		menu_id = ThisModMenuID,
		priority = 999
	})
	MenuHelper:AddDivider({
		id = __Name("AddDivider001"),
		size = 16,
		menu_id = ThisModMenuID,
		priority = 998,
	})
	__Save()
end)