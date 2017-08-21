_G.OVK_Keepers = _G.OVK_Keepers or {}

OVK_Keepers.options_menu = "OVK_Keepers_menu"
OVK_Keepers.ModPath = ModPath
OVK_Keepers.SaveFile = OVK_Keepers.SaveFile or SavePath .. "OVK_Keepers.txt"
OVK_Keepers.ModOptions = OVK_Keepers.ModPath .. "menus/modoptions.txt"
OVK_Keepers.settings = {
	groupaistatebase = 0,
	playerdriving = 0
}

function OVK_Keepers:Reset()
	self.settings = {
		no_too_far_so_move = 1,
		no_driving_so_move = 1
	}
	self:Save()
end

function OVK_Keepers:Load()
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

function OVK_Keepers:Save()
	local file = io.open(self.SaveFile, "w+")
	if file then
		file:write(json.encode(self.settings))
		file:close()
	end
end

OVK_Keepers:Load()

Hooks:Add("LocalizationManagerPostInit", "OVK_Keepers_loc", function(loc)
	LocalizationManager:load_localization_file("mods/Toggle in OVK Keepers/loc/localization.txt")
end)

function OVK_Keepers:Warning()
	local _dialog_data = {
		title = "Toggle in OVK Keepers",
		text = managers.localization:text("OVK_Keepers_menu_warning4reboot"),
		button_list = {{ text = managers.localization:text("OVK_Keepers_menu_use4ok"), is_cancel_button = true }},
		id = tostring(math.random(0,0xFFFFFFFF))
	}
	managers.system_menu:show(_dialog_data)
end

Hooks:Add("MenuManagerSetupCustomMenus", "OVK_KeepersOptions", function( menu_manager, nodes )
	MenuHelper:NewMenu( OVK_Keepers.options_menu )
end)

Hooks:Add("MenuManagerPopulateCustomMenus", "OVK_KeepersOptions", function( menu_manager, nodes )
	MenuCallbackHandler.OVK_Keepers_no_too_far_so_move_toggle_callback = function(self, item)
		OVK_Keepers.settings.no_too_far_so_move = tostring(item:value()) == "on" and 1 or 0
		OVK_Keepers:Save()
		OVK_Keepers:Warning()
	end
	local _bool = OVK_Keepers.settings.no_too_far_so_move == 1 and true or false
	MenuHelper:AddToggle({
		id = "OVK_Keepers_no_too_far_so_move_toggle_callback",
		title = "OVK_Keepers_menu_no_too_far_so_move_title",
		callback = "OVK_Keepers_no_too_far_so_move_toggle_callback",
		value = _bool,
		menu_id = OVK_Keepers.options_menu,
	})
	MenuCallbackHandler.OVK_Keepers_no_driving_so_move_toggle_callback = function(self, item)
		OVK_Keepers.settings.no_driving_so_move = tostring(item:value()) == "on" and 1 or 0
		OVK_Keepers:Save()
		OVK_Keepers:Warning()
	end
	_bool = OVK_Keepers.settings.no_driving_so_move == 1 and true or false
	MenuHelper:AddToggle({
		id = "OVK_Keepers_no_driving_so_move_toggle_callback",
		title = "OVK_Keepers_menu_no_driving_so_move_title",
		callback = "OVK_Keepers_no_driving_so_move_toggle_callback",
		value = _bool,
		menu_id = OVK_Keepers.options_menu,
	})
end)
Hooks:Add("MenuManagerBuildCustomMenus", "OVK_KeepersOptions", function(menu_manager, nodes)
	nodes[OVK_Keepers.options_menu] = MenuHelper:BuildMenu( OVK_Keepers.options_menu )
	MenuHelper:AddMenuItem( MenuHelper.menus.lua_mod_options_menu, OVK_Keepers.options_menu, "OVK_Keepers_menu_title", "OVK_Keepers_menu_desc")
end)