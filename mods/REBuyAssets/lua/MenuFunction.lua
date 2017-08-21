_G.REBuyAssets = _G.REBuyAssets or {}

REBuyAssets.menu_id = "REBuyAssets_menu_id"
REBuyAssets.ModPath = ModPath
REBuyAssets.SaveFile = REBuyAssets.SaveFile or SavePath .. "REBuyAssets.txt"

REBuyAssets.settings = {
	AutoBuyAllAssets = 1
}

function REBuyAssets:Reset()
	self.settings = {
		AutoBuyAllAssets = 1
	}
	self:Save()
end

function REBuyAssets:Load(supp, current_stage)
	local _file = io.open(self.SaveFile, "r")
	if _file then
		local _data = tostring(_file:read("*all"))
		_data = _data:gsub('%[%]', '{}')
		self.settings = json.decode(_data)
		_file:close()
		self:Save()
	else
		self:Reset()
	end
end

function REBuyAssets:Save()
	local _file = io.open(self.SaveFile, "w+")
	if _file then
		_file:write(json.encode(self.settings))
		_file:close()
	end
end

Hooks:Add("MenuManagerSetupCustomMenus", "MenuManagerSetupCustomMenus_REBuyAssets", function(menu_manager, nodes)
	MenuHelper:NewMenu(REBuyAssets.menu_id)
end)

Hooks:Add("MenuManagerPopulateCustomMenus", "MenuManagerPopulateCustomMenus_REBuyAssets", function(menu_manager, nodes)
	MenuCallbackHandler.CleanAllREBuyAssetsNow = function(self, item)
		REBuyAssets:Reset()
		QuickMenu:new(
			"RE-Buy Assets",
			"All data is removed",
			{{"Ok", is_cancel_button = true}},
			true
		):Show()
	end
	MenuCallbackHandler.CleanREBuyAssetsNow = function(self, item)
		local current_stage = managers.job:current_level_id()
		if current_stage then
			REBuyAssets.settings = REBuyAssets.settings or {}
			REBuyAssets.settings[current_stage] = {"Nah"}
			REBuyAssets:Save()
			QuickMenu:new(
				"RE-Buy Assets",
				"Data is removed",
				{{"Ok", is_cancel_button = true}},
				true
			):Show()
		end
	end
	MenuCallbackHandler.SaveREBuyAssetsNow = function(self, item)
		REBuyAssets:Save()
		QuickMenu:new(
			"RE-Buy Assets",
			"Data is saved",
			{{"Ok", is_cancel_button = true}},
			true
		):Show()
	end
	MenuCallbackHandler.AutoBuyAllAssetsNow = function(self, item)
		if tostring(item:value()) == "on" then
			REBuyAssets.settings["AutoBuyAllAssets"] = 1
		else
			REBuyAssets.settings["AutoBuyAllAssets"] = 0
		end
		REBuyAssets:Save()
	end
	MenuHelper:AddButton({
		id = "SaveREBuyAssetsNow",
		title = "menu_REBuyAssets_save_name",
		desc = "menu_REBuyAssets_save_desc",
		callback = "SaveREBuyAssetsNow",
		menu_id = REBuyAssets.menu_id,
	})
	MenuHelper:AddButton({
		id = "CleanREBuyAssetsNow",
		title = "menu_REBuyAssets_clean_name",
		desc = "menu_REBuyAssets_clean_desc",
		callback = "CleanREBuyAssetsNow",
		menu_id = REBuyAssets.menu_id,
	})
	MenuHelper:AddButton({
		id = "CleanAllREBuyAssetsNow",
		title = "menu_REBuyAssets_clean_all_name",
		desc = "menu_REBuyAssets_clean_all_desc",
		callback = "CleanAllREBuyAssetsNow",
		menu_id = REBuyAssets.menu_id,
	})
	local _bool = REBuyAssets.settings["AutoBuyAllAssets"] == 1 and true or false
	MenuHelper:AddToggle({
		id = "AutoBuyAllAssetsNow",
		title = "menu_REBuyAssets_buy_all_name",
		desc = "menu_REBuyAssets_buy_all_desc",
		callback = "AutoBuyAllAssetsNow",
		value = _bool,
		menu_id = REBuyAssets.menu_id,
	})
end)

Hooks:Add("MenuManagerBuildCustomMenus", "MenuManagerBuildCustomMenus_REBuyAssets", function(menu_manager, nodes)
	nodes[REBuyAssets.menu_id] = MenuHelper:BuildMenu(REBuyAssets.menu_id)
	MenuHelper:AddMenuItem(MenuHelper.menus.lua_mod_options_menu, REBuyAssets.menu_id, "menu_REBuyAssets_contract_name", "menu_REBuyAssets_contract_desc")
end)

Hooks:Add("LocalizationManagerPostInit", "REBuyAssets_loc", function(loc)
	LocalizationManager:add_localized_strings({
		["menu_REBuyAssets_contract_name"] = "RE-Buy Assets",
		["menu_REBuyAssets_contract_desc"] = " ...",
		["menu_REBuyAssets_save_name"] = "Save",
		["menu_REBuyAssets_save_desc"] = " ...",
		["menu_REBuyAssets_clean_name"] = "Clean",
		["menu_REBuyAssets_clean_desc"] = " ...",
		["menu_REBuyAssets_clean_all_name"] = "Clean All",
		["menu_REBuyAssets_clean_all_desc"] = " ...",
		["menu_REBuyAssets_buy_all_name"] = "Auto Buy All",
		["menu_REBuyAssets_buy_all_desc"] = " ...",
	})
end)

REBuyAssets:Load()