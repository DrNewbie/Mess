_G.WeaponKicker = _G.WeaponKicker or {}

if WeaponKicker and WeaponKicker.ModPath and WeaponKicker.Main_Options_Menu then
	return
end

WeaponKicker.ModPath = ModPath

WeaponKicker.Main_Options_Menu = "WeaponKicker_Main_Options_Menu"

Hooks:Add("LocalizationManagerPostInit", "WeaponKicker_loc", function(loc)
	LocalizationManager:add_localized_strings({
		["WeaponKicker_menu_title"] = "Weapon Kicker",
		["WeaponKicker_menu_desc"] = " ",
		["WeaponKicker_menu_empty_desc"] = " ",
		["WeaponKicker_menu_ban"] = "Ban this Weapon"
	})
end)
WeaponKicker.Settings = WeaponKicker.Settings or {}

local _, _, _, weapon_list, _, _, _, _, _ = tweak_data.statistics:statistics_table()
if weapon_list and type(weapon_list) == "table" and #weapon_list > 0 then
	WeaponKicker.All_Weapon = weapon_list
end
weapon_list = nil

function WeaponKicker:Save_Data()
	local _file = io.open(WeaponKicker.ModPath.."BanList.txt", "w+")
	if _file then
		_file:write(json.encode(self.Settings))
		_file:close()
	end
end

function WeaponKicker:Load_Data()
	local _file = io.open(WeaponKicker.ModPath.."BanList.txt", "r")
	if _file then
		self.Settings = json.decode(_file:read("*all"))
		_file:close()
	end
end

Hooks:Add("MenuManagerSetupCustomMenus", "WeaponKickerOptionsSetup", function(...)
	MenuHelper:NewMenu(WeaponKicker.Main_Options_Menu)
	local cats = {}
	for _, weapon_name in pairs(WeaponKicker.All_Weapon) do
		if tweak_data.weapon[weapon_name] and tweak_data.weapon[weapon_name].name_id then
			MenuHelper:NewMenu("WeaponKicker_".. weapon_name .."_Options_Menu")
			local cat = tostring(tweak_data.weapon[weapon_name].categories[1])
			local carn = managers.localization:to_upper_text("menu_" .. cat)
			if carn:find("ERROR") then
				cat = "wpn_special"
			end
			if not cats[cat] then
				cats[cat] = true
			end
		end
	end
	for _cat, _ in pairs(cats) do
		MenuHelper:NewMenu("WeaponKicker_Cat_".. _cat .."_Options_Menu")
	end
end)

Hooks:Add("MenuManagerBuildCustomMenus", "WeaponKickerOptionsBuild", function(menu_manager, nodes)
	nodes[WeaponKicker.Main_Options_Menu] = MenuHelper:BuildMenu(WeaponKicker.Main_Options_Menu)
	MenuHelper:AddMenuItem(nodes["blt_options"], WeaponKicker.Main_Options_Menu, "WeaponKicker_menu_title", "WeaponKicker_menu_desc")
	for _, weapon_name in pairs(WeaponKicker.All_Weapon) do
		if tweak_data.weapon[weapon_name] and tweak_data.weapon[weapon_name].name_id then
			local cat = tostring(tweak_data.weapon[weapon_name].categories[1])
			local carn = managers.localization:to_upper_text("menu_" .. cat)
			if carn:find("ERROR") then
				cat = "wpn_special"
			end
			local fcat = "WeaponKicker_Cat_".. cat .."_Options_Menu"
			if cat ~= "nil" then
				if not nodes[fcat] then
					nodes[fcat] = MenuHelper:BuildMenu(fcat)
					MenuHelper:AddMenuItem(nodes[WeaponKicker.Main_Options_Menu], fcat, "menu_" .. cat, "WeaponKicker_menu_empty_desc")
				end
				local _new = "WeaponKicker_".. weapon_name .."_Options_Menu"
				nodes[_new] = MenuHelper:BuildMenu(_new)
				MenuHelper:AddMenuItem(nodes[fcat], _new, tweak_data.weapon[weapon_name].name_id, "WeaponKicker_menu_empty_desc")
			end
		end
	end
end)

Hooks:Add("MenuManagerPopulateCustomMenus", "WeaponKickerOptionsPopulate", function(...)
	for _, weapon_name in pairs(WeaponKicker.All_Weapon) do
		if tweak_data.weapon[weapon_name] and tweak_data.weapon[weapon_name].name_id then
			MenuCallbackHandler["WeaponKicker_Ban_".. weapon_name.. "_cbk"] = function(self, item)
				WeaponKicker.Settings[weapon_name] = item:value() == "on" and true or false
				WeaponKicker:Save_Data()
			end
			MenuHelper:AddToggle({
				id = "WeaponKicker_Ban_".. weapon_name.. "_cbk",
				title = "WeaponKicker_menu_ban",
				callback = "WeaponKicker_Ban_".. weapon_name.. "_cbk",
				value = WeaponKicker.Settings[weapon_name],
				menu_id = "WeaponKicker_".. weapon_name .."_Options_Menu"
			})
		end
	end
end)

WeaponKicker:Load_Data()

function WeaponKicker:AnnounceList()
	local gcm_announcements = {}
	local i = 1
	for _id, _bool in pairs(WeaponKicker.Settings) do
		local key = "ID_"..i
		gcm_announcements[key] = gcm_announcements[key] or {}
		if table.size(gcm_announcements[key]) > 6 then
			i = i + 1
		end
		if tostring(_bool) == 'true' and tweak_data.weapon[_id] and tweak_data.weapon[_id].name_id then
			table.insert(gcm_announcements[key], managers.localization:to_upper_text(tweak_data.weapon[_id].name_id).."")
		end
	end
	return gcm_announcements
end

function WeaponKicker:DoAnnounce(peer_id)
	if not peer_id or peer_id == 1 then
		return
	end
	local gcm_announcements = self:AnnounceList()
	local i = 1
	for id, data in pairs(gcm_announcements) do
		DelayedCalls:Add("WeaponKickerDoAnnounceDelay_"..tostring(peer_id).."_"..id, 3*i, function()
			local message = "[WeaponKicker]: List of Banned\n" .. table.concat(data, ", ") .. "."
			local peer_an = managers.network:session() and managers.network:session():peer(peer_id)
			if peer_an then
				peer_an:send("send_chat_message", ChatManager.GAME, message)
			end
		end)
		i = i + 1
	end
end

Hooks:Add("NetworkManagerOnPeerAdded", "WeaponKickerAnnounce_1", function(peer, peer_id)
	WeaponKicker:DoAnnounce(peer_id)
end)

if ModCore then
	ModCore:new(WeaponKicker.ModPath .. "Config.xml", false, true):init_modules()
end