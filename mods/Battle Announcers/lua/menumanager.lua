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
		["battle_announcers_menu_desc"] = " "
	})
end)

Hooks:Add("MenuManagerPopulateCustomMenus", __Name("MenuManagerPopulateCustomMenus"), function(menu_manager, nodes)
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
	__Save()
end)