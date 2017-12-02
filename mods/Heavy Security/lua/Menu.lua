_G.HeavySecurity = _G.HeavySecurity or {}

if Network:is_client() then
	return
end

HeavySecurity.options_menu = "HeavySecurity_menu"
HeavySecurity.ModPath = ModPath
HeavySecurity.SaveFile = HeavySecurity.SaveFile or SavePath .. "HeavySecurity.txt"
HeavySecurity.settings = HeavySecurity.settings or {}

function HeavySecurity:Reset()
	self.settings = {
		Level = 1,
		Enemy_Type = 1,
	}
	self:Save()
end

function HeavySecurity:Load()
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

function HeavySecurity:Save()
	local file = io.open(self.SaveFile, "w+")
	if file then
		file:write(json.encode(self.settings))
		file:close()
	end
end

HeavySecurity:Load()

Hooks:Add("LocalizationManagerPostInit", "HeavySecurity_loc", function(loc)
	LocalizationManager:add_localized_strings({
		["HeavySecurity_menu_title"] = "Heavy Security",
		["HeavySecurity_menu_desc"] = "",
		["HeavySecurity_menu_level_title"] = "Security Level",
		["HeavySecurity_menu_level_desc"] = "",
		["HeavySecurity_menu_enemy_type_title"] = "Enemy Type",
		["HeavySecurity_menu_enemy_type_desc"] = "",
		["HeavySecurity_menu_enemy_type_1"] = "Green Dozer",
		["HeavySecurity_menu_enemy_type_2"] = "Black Dozer",
		["HeavySecurity_menu_enemy_type_3"] = "Skull Dozer",
		["HeavySecurity_menu_enemy_type_4"] = "Cloaker",
		["HeavySecurity_menu_enemy_type_5"] = "Shield",
		["HeavySecurity_menu_enemy_type_6"] = "Taser"
	})
end)

Hooks:Add("MenuManagerSetupCustomMenus", "HeavySecurityOptions", function( menu_manager, nodes )
	MenuHelper:NewMenu( HeavySecurity.options_menu )
end)

Hooks:Add("MenuManagerPopulateCustomMenus", "HeavySecurityOptions", function( menu_manager, nodes )
	MenuCallbackHandler.HeavySecurity_menu_delay_callback = function(self, item)
		HeavySecurity.settings.Level = math.floor(item:value())
		HeavySecurity:Save()
	end
	MenuHelper:AddSlider({
		id = "HeavySecurity_menu_delay_callback",
		title = "HeavySecurity_menu_level_title",
		callback = "HeavySecurity_menu_delay_callback",
		value = HeavySecurity.settings.Level,
		min = 1,
		max = 10,
		step = 1,
		show_value = true,
		menu_id = HeavySecurity.options_menu,  
	})
	MenuCallbackHandler.HeavySecurity_menu_enemy_type_callback = function(self, item)
		HeavySecurity.settings.Enemy_Type = item:value()
		HeavySecurity:Save()
	end
	MenuHelper:AddMultipleChoice({
		id = "HeavySecurity_menu_enemy_type_callback",
		title = "HeavySecurity_menu_enemy_type_title",
		desc = "HeavySecurity_menu_enemy_type_desc",
		callback = "HeavySecurity_menu_enemy_type_callback",
		items = {"HeavySecurity_menu_enemy_type_1", "HeavySecurity_menu_enemy_type_2", "HeavySecurity_menu_enemy_type_3", "HeavySecurity_menu_enemy_type_4", "HeavySecurity_menu_enemy_type_5", "HeavySecurity_menu_enemy_type_6"},
		value = HeavySecurity.settings.Enemy_Type,
		menu_id = HeavySecurity.options_menu,
	})
end)

Hooks:Add("MenuManagerBuildCustomMenus", "HeavySecurityOptions", function(menu_manager, nodes)
	nodes[HeavySecurity.options_menu] = MenuHelper:BuildMenu( HeavySecurity.options_menu )
	MenuHelper:AddMenuItem(nodes["blt_options"], HeavySecurity.options_menu, "HeavySecurity_menu_title", "HeavySecurity_menu_desc")
end)

if Announcer then
	Announcer:AddHostMod("Heavy Security, ( http://modwork.shop/16274 )")
end

if ModCore then
	ModCore:new(HeavySecurity.ModPath .. "Config.xml", false, true):init_modules()
end