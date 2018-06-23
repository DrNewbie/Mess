if not ModCore then
	log("[ERROR] BeardLib is not installed!")
	return
end

_G.FileReloader = _G.FileReloader or {}
FileReloader.ModPath = ModPath
FileReloader.AssetsPath = FileReloader.ModPath.."/assets/"
FileReloader.ModOptions = FileReloader.ModPath.."menus/modoptions.txt"

ModCore:new(FileReloader.ModPath.."Config.xml", true, true)

function FileReloader:choose_folder_after_type(data)
	local _Directory, _Config = FileReloader.AssetsPath..data.folder, {}
	for _, d in pairs(data) do
		if type(d) == "table" and d.path and d.format then
			table.insert(_Config, {
				_meta = d.format,
				path = d.path,
				force = true
			})
		end
	end
	if data.listme then
		local _base_path = Application:base_path()
		local _new_path = Application:nice_path(_base_path.._Directory, false)
		local cmd = string.format('DIR "%s\\" /S /A:-D /B /O:N > "%s\\listme.txt"', _new_path, _new_path)
		os.execute(cmd)
	end
	CustomPackageManager:LoadPackageConfig(_Directory, _Config)
end

Hooks:Add("MenuManagerInitialize", "MenuManagerInitialize_FileReloader", function(menu_manager)
	MenuCallbackHandler.FileReloader_Choose_Folder_callback = function()
		local opts = {}
		for _, name in pairs(file.GetDirectories(FileReloader.AssetsPath) or {}) do
			local _path_file = io.open(FileReloader.AssetsPath..name.. "/path.json", "r")
			if _path_file then
				local _date = _path_file:read("*all")
				local _decode_date = json.decode(_date)
				_path_file:close()
				_decode_date.folder = name
				opts[#opts+1] = {
					text="".. name:format("%q") .."",
					callback_func = callback(FileReloader, FileReloader, "choose_folder_after_type",
						_decode_date
					)
				}
			end
		end
		opts[#opts+1] = { text = managers.localization:text("FileReloader_use4cancel"), is_cancel_button = true }
		managers.system_menu:show({
			title = managers.localization:text("FileReloader_menu_title"),
			text = managers.localization:text("FileReloader_menu_change_settings_main_text"),
			button_list = opts,
			id = tostring(math.random(0,0xFFFFFFFF))
		})
	end	
	MenuHelper:LoadFromJsonFile(FileReloader.ModPath.."menu/options.txt", FileReloader, FileReloader.settings)
end)