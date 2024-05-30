_G.SaveMyArt = _G.SaveMyArt or {}

SaveMyArt.menu_id = "SaveMyArt_menu_id"
SaveMyArt.ModPath = ModPath

Hooks:Add("LocalizationManagerPostInit", "SaveMyArt_loc", function(loc)
	LocalizationManager:add_localized_strings({
		["menu_SaveMyArt_contract_name"] = "Save My Art",
		["menu_SaveMyArt_contract_desc"] = "  ",
		["menu_SaveMyArt_start_name"] = "Start",
		["menu_SaveMyArt_start_desc"] = "Start record your drawing",
		["menu_SaveMyArt_save_name"] = "Save",
		["menu_SaveMyArt_save_desc"] = " ",
		["menu_SaveMyArt_cancel_name"] = "Cancel",
		["menu_SaveMyArt_cancel_desc"] = "Stop recording",
		["menu_SaveMyArt_load_name"] = "Load",
		["menu_SaveMyArt_load_desc"] = "Load your art"
	})
end)

function SaveMyArt:Save(id, data)
	io.save_as_json(data, self.ModPath.."Art/"..id..".json")
	return
end

function SaveMyArt:Clean()
	self.Start = nil
	self.Current_ID = nil
	self.Current_DATA = nil
	self.Read2Put = nil
	return
end

function SaveMyArt:Choose(data)
	if type(data) ~= "table" or not data.file_name then
		return
	end
	self.Read2Put = io.load_as_json(self.ModPath.."Art/"..data.file_name)
	if type(self.Read2Put) == "table" and managers.system_menu then
		managers.system_menu:show({
			title = "[SaveMyArt]",
			text = "Load: "..data.file_name,
			button_list = {{ text = "[Close]", is_cancel_button = true }},
			id = tostring(math.random(0,0xFFFFFFFF))
		})
		managers.system_menu:show({
			title = "[SaveMyArt]",
			text = "Now go to panel and use pen to click one time.",
			button_list = {{ text = "[Close]", is_cancel_button = true }},
			id = tostring(math.random(0,0xFFFFFFFF))
		})
	end
	return
end

Hooks:Add( "MenuManagerSetupCustomMenus" , "MenuManagerSetupCustomMenus_SaveMyArt" , function()
	MenuHelper:NewMenu(SaveMyArt.menu_id)
end)

Hooks:Add("MenuManagerPopulateCustomMenus", "MenuManagerPopulateCustomMenus_SaveMyArt", function()
	MenuCallbackHandler.StartSaveMyArtClbk = function(self, item)
		SaveMyArt:Clean()
		SaveMyArt.Start = true
		SaveMyArt.Current_ID = "ID_"..Idstring(tostring(os.time())):key()
		SaveMyArt.Current_DATA = {}
		if managers.system_menu then
			managers.system_menu:show({
				title = "[SaveMyArt]",
				text = "Recording!!",
				button_list = {{ text = "[Close]", is_cancel_button = true }},
				id = tostring(math.random(0,0xFFFFFFFF))
			})
		end
	end
	MenuHelper:AddButton({
		id = "StartSaveMyArt",
		title = "menu_SaveMyArt_start_name",
		desc = "menu_SaveMyArt_start_desc",
		callback = "StartSaveMyArtClbk",
		menu_id = SaveMyArt.menu_id
	})
	MenuCallbackHandler.SaveSaveMyArtClbk = function(self, item)
		if type(SaveMyArt.Current_ID) == "string" and type(SaveMyArt.Current_DATA) == "table" and SaveMyArt.Current_DATA[1] then
			SaveMyArt:Save(SaveMyArt.Current_ID, SaveMyArt.Current_DATA)
			if managers.system_menu then
				managers.system_menu:show({
					title = "[SaveMyArt]",
					text = "Your art is saved to '"..SaveMyArt.Current_ID..".json'",
					button_list = {{ text = "[Close]", is_cancel_button = true }},
					id = tostring(math.random(0,0xFFFFFFFF))
				})
			end
		end
		SaveMyArt:Clean()
	end
	MenuHelper:AddButton({
		id = "SaveSaveMyArt",
		title = "menu_SaveMyArt_save_name",
		desc = "menu_SaveMyArt_save_desc",
		callback = "SaveSaveMyArtClbk",
		menu_id = SaveMyArt.menu_id
	})
	MenuCallbackHandler.CancelSaveMyArtClbk = function(self, item)
		SaveMyArt:Clean()
	end
	MenuHelper:AddButton({
		id = "CancelSaveMyArt",
		title = "menu_SaveMyArt_cancel_name",
		desc = "menu_SaveMyArt_cancel_desc",
		callback = "CancelSaveMyArtClbk",
		menu_id = SaveMyArt.menu_id
	})
	MenuCallbackHandler.LoadSaveMyArtClbk = function(self, item)
		if not managers.system_menu then
			return
		end
		local _files = {}
		for _, name in pairs(file.GetFiles(SaveMyArt.ModPath.."Art/") or {}) do
			table.insert(_files, name)
		end
		local opts = {}
		for _, name in pairs (_files) do
			opts[#opts+1] = { text = "[ "..name.." ]", callback_func = callback(SaveMyArt, SaveMyArt, "Choose", {file_name = name}) }
		end
		opts[#opts+1] = { text = "[Close]", is_cancel_button = true }
		managers.system_menu:show({
			title = "[SaveMyArt]",
			text = "Choose one",
			button_list = opts,
			id = tostring(math.random(0,0xFFFFFFFF))
		})
	end
	MenuHelper:AddButton({
		id = "LoadSaveMyArt",
		title = "menu_SaveMyArt_load_name",
		desc = "menu_SaveMyArt_load_desc",
		callback = "LoadSaveMyArtClbk",
		menu_id = SaveMyArt.menu_id
	})
end)

Hooks:Add("MenuManagerBuildCustomMenus", "MenuManagerBuildCustomMenus_SaveMyArt", function(menu_manager, nodes)
	nodes[SaveMyArt.menu_id] = MenuHelper:BuildMenu(SaveMyArt.menu_id)
	MenuHelper:AddMenuItem(nodes["blt_options"], SaveMyArt.menu_id, "menu_SaveMyArt_contract_name", "menu_SaveMyArt_contract_desc")
end)

if ModCore then
	ModCore:new(SaveMyArt.ModPath.."Config.xml", false, true):init_modules()
end

-->>https://modworkshop.net/mod/14734
tweak_data.preplanning.gui.MAX_DRAW_POINTS = math.pow(2, 30)
--<<