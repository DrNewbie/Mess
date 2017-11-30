_G.SomeonNotHome = _G.SomeonNotHome or {}
SomeonNotHome.ModPath = ModPath
SomeonNotHome.SaveFile = SavePath .. "SomeonNotHome.txt"
SomeonNotHome.Main_Options_Menu = "SomeonNotHome_Main_Options_Menu"
SomeonNotHome.SomeonNotHome_Options_Crew = "SomeonNotHome_Options_Crew"
SomeonNotHome.SomeonNotHome_Options_Other = "SomeonNotHome_Options_Other"
SomeonNotHome.Settings = SomeonNotHome.Settings or {}
SomeonNotHome.All_Character = {}

if ModCore then
	ModCore:new(SomeonNotHome.ModPath.."Updater.xml", false, true):init_modules()
end

if not tweak_data or not tweak_data.statistics then
	return
end

Hooks:Add("LocalizationManagerPostInit", "SomeonNotHome_loc", function(loc)
	LocalizationManager:add_localized_strings({
		["SomeonNotHome_menu_title"] = "Someon is not at safehouse",
		["SomeonNotHome_menu_desc"] = "Who is not at safehouse now?",
		["SomeonNotHome_menu_empty_desc"] = " ",
		["SomeonNotHome_menu_Crew_title"] = "Payday Gang",
		["SomeonNotHome_menu_Other_title"] = "Others"
	})
end )

local _, _, _, _, _, _, _, _, character_list = tweak_data.statistics:statistics_table()
if character_list and type(character_list) == "table" and #character_list > 0 then
	SomeonNotHome.All_Character = character_list
end
character_list = nil

function SomeonNotHome:Reset()
	self.Settings['Unknown'] = true
	self:Save()
end

function SomeonNotHome:Load()
	local file = io.open(self.SaveFile, "r")
	if file then
		for key, value in pairs(json.decode(file:read("*all"))) do
			self.Settings[key] = value
		end
		file:close()
	else
		self:Reset()
	end
end

function SomeonNotHome:Save()
	local file = io.open(self.SaveFile, "w+")
	if file then
		file:write(json.encode(self.Settings))
		file:close()
	end
end

Hooks:Add("MenuManagerSetupCustomMenus", "SomeonNotHomeOptionsSetup", function(...)
	MenuHelper:NewMenu(SomeonNotHome.Main_Options_Menu)
	MenuHelper:NewMenu(SomeonNotHome.SomeonNotHome_Options_Crew)
	MenuHelper:NewMenu(SomeonNotHome.SomeonNotHome_Options_Other)
	for _, _name in ipairs(SomeonNotHome.All_Character) do
		MenuHelper:NewMenu("SomeonNotHome_".. _name .."_Options_Menu")
	end
end )

Hooks:Add("MenuManagerBuildCustomMenus", "SomeonNotHomeOptionsBuild", function(menu_manager, nodes)
	nodes[SomeonNotHome.Main_Options_Menu] = MenuHelper:BuildMenu(SomeonNotHome.Main_Options_Menu)
	nodes[SomeonNotHome.SomeonNotHome_Options_Crew] = MenuHelper:BuildMenu(SomeonNotHome.SomeonNotHome_Options_Crew)
	nodes[SomeonNotHome.SomeonNotHome_Options_Other] = MenuHelper:BuildMenu(SomeonNotHome.SomeonNotHome_Options_Other)
	MenuHelper:AddMenuItem(nodes["blt_options"], SomeonNotHome.Main_Options_Menu, "SomeonNotHome_menu_title", "SomeonNotHome_menu_desc")
	MenuHelper:AddMenuItem(nodes[SomeonNotHome.Main_Options_Menu], SomeonNotHome.SomeonNotHome_Options_Crew, "SomeonNotHome_menu_Crew_title", "SomeonNotHome_menu_desc")
	MenuHelper:AddMenuItem(nodes[SomeonNotHome.Main_Options_Menu], SomeonNotHome.SomeonNotHome_Options_Other, "SomeonNotHome_menu_Other_title", "SomeonNotHome_menu_desc")
end)

Hooks:Add("MenuManagerPopulateCustomMenus", "SomeonNotHomeOptionsPopulate", function(...)
	for _, _name in ipairs(SomeonNotHome.All_Character) do
		MenuCallbackHandler["SomeonNotHome_".. _name.. "_callback"] = function(self, item)
			SomeonNotHome.Settings[_name] = item:value() == "on" and true or false
			SomeonNotHome:Save()
		end
		MenuHelper:AddToggle({
			id = "SomeonNotHome_".. _name.. "_callback",
			title = "menu_".._name,
			callback = "SomeonNotHome_".. _name.. "_callback",
			value = SomeonNotHome.Settings[_name],
			menu_id = SomeonNotHome.SomeonNotHome_Options_Crew,  
		})
	end
	for _, _name in ipairs({"butler", "yakuza_001", "yakuza_002", "bartender", "vlad", "vlad_girl001", "vlad_girl002", "vlad_girl003", "vlad_girl004", "Max", "butler_room_001", "butler_room_002"}) do
		LocalizationManager:add_localized_strings({
			["SomeonNotHome_".._name] = _name
		})
		MenuCallbackHandler["SomeonNotHome_".. _name.. "_callback"] = function(self, item)
			SomeonNotHome.Settings[_name] = item:value() == "on" and true or false
			SomeonNotHome:Save()
		end
		MenuHelper:AddToggle({
			id = "SomeonNotHome_".. _name.. "_callback",
			title = "SomeonNotHome_".._name,
			callback = "SomeonNotHome_".. _name.. "_callback",
			value = SomeonNotHome.Settings[_name],
			menu_id = SomeonNotHome.SomeonNotHome_Options_Other,  
		})
	end
end )

SomeonNotHome:Load()