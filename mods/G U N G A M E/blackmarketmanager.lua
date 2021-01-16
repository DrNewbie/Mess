_G.GunGameGame = _G.GunGameGame or {}

GunGameGame.options_menu = "GunGameGame_menu"
GunGameGame.ModPath = ModPath
GunGameGame.SaveFile = GunGameGame.SaveFile or SavePath .. "GunGameGame.txt"
GunGameGame.settings = GunGameGame.settings or {}

function GunGameGame:Reset()
	self.settings = {
		chance = 30,
		rndMod = 0
	}
	self:Save()
end

function GunGameGame:Load()
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

function GunGameGame:Save()
	local file = io.open(self.SaveFile, "w+")
	if file then
		file:write(json.encode(self.settings))
		file:close()
	end
end

GunGameGame:Load()

Hooks:Add("LocalizationManagerPostInit", "GunGameGame_loc", function(loc)
	LocalizationManager:add_localized_strings({
		["GunGameGame_menu_title"] = "G U N G A M E",
		["GunGameGame_menu_desc"] = "",
		["GunGameGame_menu_chance_title"] = "Chance of Additional Weapons",
		["GunGameGame_menu_rndMod_title"] = "Chance of Randomizer (Additional Weps)"
	})
end)

Hooks:Add("MenuManagerSetupCustomMenus", "GunGameGameOptions", function()
	MenuHelper:NewMenu(GunGameGame.options_menu)
end)

Hooks:Add("MenuManagerPopulateCustomMenus", "GunGameGameOptions", function( menu_manager, nodes )
	MenuCallbackHandler.GunGameGame_menu_chance_callback = function(self, item)
		GunGameGame.settings.chance = math.floor(item:value())
		GunGameGame:Save()
	end
	MenuHelper:AddSlider({
		id = "GunGameGame_menu_chance_slider",
		title = "GunGameGame_menu_chance_title",
		callback = "GunGameGame_menu_chance_callback",
		value = GunGameGame.settings.chance,
		min = 0,
		max = 100,
		step = 1,
		show_value = true,
		menu_id = GunGameGame.options_menu,  
	})
	MenuCallbackHandler.GunGameGame_menu_rndMod_callback = function(self, item)
		GunGameGame.settings.rndMod = math.floor(item:value())
		GunGameGame:Save()
	end
	MenuHelper:AddSlider({
		id = "GunGameGame_menu_rndMod_slider",
		title = "GunGameGame_menu_rndMod_title",
		callback = "GunGameGame_menu_rndMod_callback",
		value = GunGameGame.settings.rndMod,
		min = 0,
		max = 100,
		step = 1,
		show_value = true,
		menu_id = GunGameGame.options_menu,  
	})
end)

Hooks:Add("MenuManagerBuildCustomMenus", "GunGameGameOptions", function(menu_manager, nodes)
	nodes[GunGameGame.options_menu] = MenuHelper:BuildMenu(GunGameGame.options_menu)
	MenuHelper:AddMenuItem(nodes["blt_options"], GunGameGame.options_menu, "GunGameGame_menu_title", "GunGameGame_menu_desc")
end)