_G.AddBulletTrail = _G.AddBulletTrail or {}
AddBulletTrail.ModPath = ModPath
AddBulletTrail.SaveFile = SavePath .. "AddBulletTrail.txt"
AddBulletTrail.Main_Options_Menu = "AddBulletTrail_Main_Options_Menu"
AddBulletTrail.Settings = AddBulletTrail.Settings or {}
AddBulletTrail.All_Weapon = {}

if not tweak_data or not tweak_data.statistics then
	return
end

Hooks:Add("LocalizationManagerPostInit", "AddBulletTrail_loc", function(loc)
	LocalizationManager:add_localized_strings({
		["AddBulletTrail_menu_title"] = "Bullet Trail",
		["AddBulletTrail_menu_desc"] = "...",
		["AddBulletTrail_menu_empty_desc"] = "..."
	})
end )

local _, _, _, weapon_list, _, _, _, _, _ = tweak_data.statistics:statistics_table()
if weapon_list and type(weapon_list) == "table" and #weapon_list > 0 then
	AddBulletTrail.All_Weapon = weapon_list
end
weapon_list = nil

function AddBulletTrail:Load()
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

function AddBulletTrail:Save()
	local file = io.open(self.SaveFile, "w+")
	if file then
		file:write(json.encode(self.Settings))
		file:close()
	end
end

Hooks:Add("MenuManagerSetupCustomMenus", "AddBulletTrailOptionsSetup", function(...)
	MenuHelper:NewMenu(AddBulletTrail.Main_Options_Menu)
	for _, weapon_name in pairs(AddBulletTrail.All_Weapon) do
		if tweak_data.weapon[weapon_name] and tweak_data.weapon[weapon_name].name_id then
			MenuHelper:NewMenu("AddBulletTrail_".. weapon_name .."_Options_Menu")
		end
	end
end )

Hooks:Add("MenuManagerBuildCustomMenus", "AddBulletTrailOptionsBuild", function(menu_manager, nodes)
	nodes[AddBulletTrail.Main_Options_Menu] = MenuHelper:BuildMenu(AddBulletTrail.Main_Options_Menu)
	MenuHelper:AddMenuItem(MenuHelper.menus.lua_mod_options_menu, AddBulletTrail.Main_Options_Menu, "AddBulletTrail_menu_title", "AddBulletTrail_menu_desc")
end)

Hooks:Add("MenuManagerPopulateCustomMenus", "AddBulletTrailOptionsPopulate", function(...)
	local _setting = AddBulletTrail.States_Setting or {}
	for _, weapon_name in pairs(AddBulletTrail.All_Weapon) do
		if tweak_data.weapon[weapon_name] and tweak_data.weapon[weapon_name].name_id then
			MenuCallbackHandler["AddBulletTrail_".. weapon_name.. "_callback"] = function(self, item)
				AddBulletTrail.Settings[weapon_name] = item:value() == "on" and true or false
				AddBulletTrail:Save()
			end
			MenuHelper:AddToggle({
				id = "AddBulletTrail_".. weapon_name.. "_callback",
				title = tweak_data.weapon[weapon_name].name_id,
				callback = "AddBulletTrail_".. weapon_name.. "_callback",
				value = AddBulletTrail.Settings[weapon_name],
				menu_id = AddBulletTrail.Main_Options_Menu,  
			})
		end
	end
end )

AddBulletTrail:Load()