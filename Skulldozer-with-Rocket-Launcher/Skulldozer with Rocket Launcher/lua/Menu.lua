_G.SkulldozerRPG = _G.SkulldozerRPG or {}

if Network:is_client() then
	return
end

SkulldozerRPG.options_menu = "SkulldozerRPG_menu"
SkulldozerRPG.ModPath = ModPath
SkulldozerRPG.SaveFile = SkulldozerRPG.SaveFile or SavePath .. "SkulldozerRPG.txt"
SkulldozerRPG.ModOptions = SkulldozerRPG.ModPath .. "menus/modoptions.txt"
SkulldozerRPG.settings = SkulldozerRPG.settings or {}

function SkulldozerRPG:Reset()
	self.settings = {
		UseWhat = 1,
		Speed = 1,
	}
	self:Save()
end

function SkulldozerRPG:Load()
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

function SkulldozerRPG:Save()
	local file = io.open(self.SaveFile, "w+")
	if file then
		file:write(json.encode(self.settings))
		file:close()
	end
end

SkulldozerRPG:Load()

Hooks:Add("LocalizationManagerPostInit", "SkulldozerRPG_loc", function(loc)
	LocalizationManager:add_localized_strings({
		["SkulldozerRPG_menu_title"] = "Skulldozer with Rocket Launcher",
		["SkulldozerRPG_menu_desc"] = "",
		["SkulldozerRPG_menu_UseWhat_title"] = "Fire what thing",
		["SkulldozerRPG_menu_UseWhat_desc"] = "",
		["SkulldozerRPG_menu_Speed_title"] = "How fast it is",
		["SkulldozerRPG_menu_Speed_desc"] = "",
		["SkulldozerRPG_menu_UseWhat_type_1"] = "Rocket",
		["SkulldozerRPG_menu_UseWhat_type_2"] = "Grenade",
		["SkulldozerRPG_menu_UseWhat_type_3"] = "Howitzer",
	})
end)

Hooks:Add("MenuManagerSetupCustomMenus", "SkulldozerRPGOptions", function( menu_manager, nodes )
	MenuHelper:NewMenu( SkulldozerRPG.options_menu )
end)

Hooks:Add("MenuManagerPopulateCustomMenus", "SkulldozerRPGOptions", function( menu_manager, nodes )
	MenuCallbackHandler.SkulldozerRPG_menu_Speed_callback = function(self, item)
		SkulldozerRPG.settings.Speed = math.round_with_precision(item:value(), 2)
		SkulldozerRPG:Save()
	end
	MenuHelper:AddSlider({
		id = "SkulldozerRPG_menu_Speed_callback",
		title = "SkulldozerRPG_menu_Speed_title",
		desc = "SkulldozerRPG_menu_Speed_desc",
		callback = "SkulldozerRPG_menu_Speed_callback",
		value = SkulldozerRPG.settings.Speed,
		min = 0.05,
		max = 10,
		step = 0.05,
		show_value = true,
		menu_id = SkulldozerRPG.options_menu,
	})
	MenuCallbackHandler.SkulldozerRPG_menu_UseWhat_callback = function(self, item)
		SkulldozerRPG.settings.UseWhat = item:value()
		SkulldozerRPG:Save()
	end
	MenuHelper:AddMultipleChoice({
		id = "SkulldozerRPG_menu_UseWhat_callback",
		title = "SkulldozerRPG_menu_UseWhat_title",
		desc = "SkulldozerRPG_menu_UseWhat_desc",
		callback = "SkulldozerRPG_menu_UseWhat_callback",
		items = {"SkulldozerRPG_menu_UseWhat_type_1", "SkulldozerRPG_menu_UseWhat_type_2", "SkulldozerRPG_menu_UseWhat_type_3"},
		value = SkulldozerRPG.settings.UseWhat,
		menu_id = SkulldozerRPG.options_menu,
	})
end)

Hooks:Add("MenuManagerBuildCustomMenus", "SkulldozerRPGOptions", function(menu_manager, nodes)
	nodes[SkulldozerRPG.options_menu] = MenuHelper:BuildMenu( SkulldozerRPG.options_menu )
	MenuHelper:AddMenuItem( MenuHelper.menus.lua_mod_options_menu, SkulldozerRPG.options_menu, "SkulldozerRPG_menu_title", "SkulldozerRPG_menu_desc", 1 )
end)