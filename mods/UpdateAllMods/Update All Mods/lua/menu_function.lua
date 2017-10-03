_G.UpdateAllBLTMod = _G.UpdateAllBLTMod or {}
UpdateAllBLTMod.ModPath = ModPath
UpdateAllBLTMod.SaveFile = UpdateAllBLTMod.SaveFile or SavePath .. "UpdateAllBLTMod.txt"
UpdateAllBLTMod.DataPath = UpdateAllBLTMod.ModPath .. "UpdateAllBLTMod.txt"
UpdateAllBLTMod.menu_id = "UpdateAllBLTMod_menu_id"

UpdateAllBLTMod.Selected_Toggle = {
	BeardLibUpdateSkip = true
}

function UpdateAllBLTMod:Selected_Toggle_Save()
	local _file = io.open(self.SaveFile, "w+")
	if _file then
		_file:write(json.encode(self.Selected_Toggle))
		_file:close()
	else
		self:Selected_Toggle_Reset()
	end
end

function UpdateAllBLTMod:Selected_Toggle_Reset()
	self.Selected_Toggle = {
		BeardLibUpdateSkip = true
	}
	self:Selected_Toggle_Save()
end

function UpdateAllBLTMod:Selected_Toggle_Load(supp, current_stage)
	local _file = io.open(self.SaveFile, "r")
	if _file then
		self.Selected_Toggle = json.decode(_file:read("*all"))
		_file:close()
		self:Selected_Toggle_Save()
	end
end
		
Hooks:Add("MenuManagerSetupCustomMenus", "MenuManagerSetupCustomMenus_UpdateAllBLTMod", function(menu_manager, nodes)
	MenuHelper:NewMenu(UpdateAllBLTMod.menu_id)
end)

Hooks:Add("MenuManagerPopulateCustomMenus", "MenuManagerPopulateCustomMenus_UpdateAllBLTMod", function(menu_manager, nodes)
	local _bool = true
	MenuCallbackHandler["menu_UpdateAllBLTMod_BeardLibUpdateSkip_callback"] = function(self, item)
		UpdateAllBLTMod.Selected_Toggle["BeardLibUpdateSkip"] = tostring(item:value()) == "on" and true or false
		UpdateAllBLTMod:Selected_Toggle_Save()
	end
	_bool = UpdateAllBLTMod.Selected_Toggle["BeardLibUpdateSkip"] == true and true or false
	MenuHelper:AddToggle({
		id = "menu_UpdateAllBLTMod_BeardLibUpdateSkip_callback",
		title = "menu_UpdateAllBLTMod_BeardLibUpdateSkip_title",
		desc = "menu_UpdateAllBLTMod_BeardLibUpdateSkip_desc",
		callback = "menu_UpdateAllBLTMod_BeardLibUpdateSkip_callback",
		value = _bool,
		menu_id = UpdateAllBLTMod.menu_id,
	})
end)

Hooks:Add("MenuManagerBuildCustomMenus", "MenuManagerBuildCustomMenus_UpdateAllBLTMod", function(menu_manager, nodes)
	nodes[UpdateAllBLTMod.menu_id] = MenuHelper:BuildMenu(UpdateAllBLTMod.menu_id)
	MenuHelper:AddMenuItem(MenuHelper.menus.lua_mod_options_menu, UpdateAllBLTMod.menu_id, "menu_UpdateAllBLTMod_name", "menu_UpdateAllBLTMod_decs")
end)

Hooks:Add("LocalizationManagerPostInit", "UpdateAllBLTMod_loc", function(loc)
	LocalizationManager:add_localized_strings({
		["menu_UpdateAllBLTMod_name"] = "Update All Mods",
		["menu_UpdateAllBLTMod_decs"] = "Do it!!!",
		["menu_UpdateAllBLTMod_BeardLibUpdateSkip_title"] = "Skip Beardlib Updates",
		["menu_UpdateAllBLTMod_BeardLibUpdateSkip_desc"] = "Do not ask me, just do it"
	})
end)

UpdateAllBLTMod:Selected_Toggle_Load()