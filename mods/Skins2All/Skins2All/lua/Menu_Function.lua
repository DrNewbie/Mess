Hooks:Add("LocalizationManagerPostInit", "Skins2All_loc", function(loc)
	LocalizationManager:add_localized_strings({
		["Skins2All_menu_title"] = "Skins2All",
		["Skins2All_menu_desc"] = " ",
		["Skins2All_menu_forced_update_officially_title"] = "Update , Only Officially",
		["Skins2All_menu_forced_update_officially_desc"] = " ",
		["Skins2All_menu_forced_update_all_title"] = "Update , All",
		["Skins2All_menu_forced_update_all_desc"] = " ",
	})
end)

Hooks:Add("MenuManagerSetupCustomMenus", "Skins2AllOptions", function( menu_manager, nodes )
	MenuHelper:NewMenu( "Skins2All_menu" )
end)

Hooks:Add("MenuManagerPopulateCustomMenus", "Skins2AllOptions", function( menu_manager, nodes )
	MenuCallbackHandler.Skins2All_menu_forced_update_all_callback = function(self, item)
		item = item or {}
		item.update_all = true
		MenuCallbackHandler.Skins2All_menu_forced_update_callback(self, item)
	end	
	MenuCallbackHandler.Skins2All_menu_forced_update_callback = function(self, item)
		local _file = io.open('mods/Skins2All/lua/weaponskinstweakdata.lua', "w+")
		if _file then
			local _, _, _, _weapon_lists, _, _, _, _, _ = tweak_data.statistics:statistics_table()
			local _factory_id = ""
			if item.update_all then
				_weapon_lists = {}
				for _weapon_id, _ in pairs(tweak_data.weapon) do
					_factory_id = managers.weapon_factory:get_factory_id_by_weapon_id(_weapon_id)
					if _factory_id then
						table.insert(_weapon_lists, _weapon_id)
					end
				end
			end
			local _skins_list = tweak_data.blackmarket.weapon_skins or {}
			_file:write('Hooks:PostHook(BlackMarketTweakData, "_init_weapon_skins", "Skins2All_AddNew", function(skins, ...)\n')
			local _skins_name_list = {}
			for _skins_name, _skins_data in pairs(_skins_list) do
				if not _skins_name:find('_skins2all_') and managers.blackmarket:have_inventory_tradable_item("weapon_skins", _skins_name) then
					if _skins_data and _skins_data.weapon_id and type(_skins_data.weapon_id) == "string" then
						_factory_id = managers.weapon_factory:get_factory_id_by_weapon_id(_skins_data.weapon_id)
						if _factory_id then
							table.insert(_skins_name_list, _skins_name)
							for _, _weapon_id in pairs(_weapon_lists) do
								if _weapon_id ~= _skins_data.weapon_id then
									local _clone_skins = _skins_name .. '_skins2all_' .. _weapon_id
									_file:write('	skins.weapon_skins.'.. _clone_skins ..' = deep_clone(skins.weapon_skins.'.. _skins_name ..')\n')
									_file:write('	skins.weapon_skins.'.. _clone_skins ..'.weapon_id = "'.. _weapon_id ..'"\n')
									_file:write('	skins.weapon_skins.'.. _clone_skins ..'.default_blueprint = nil\n')
									_file:write('	skins.weapon_skins.'.. _clone_skins ..'.weapon_ids = nil\n')
								end
							end
						end
					end
				end
			end
			_file:write('	log("[Skins2All] '.. table.size(_skins_name_list) ..'")\n')
			_file:write('end)\n')
			_file:close()
			local _dialog_data = {
				title = "[Skins2All]",
				text = "Please reboot the game.",
				button_list = {{ text = "[OK]", is_cancel_button = true }},
				id = tostring(math.random(0,0xFFFFFFFF))
			}
			managers.system_menu:show(_dialog_data)
		end
	end
	MenuHelper:AddButton({
		id = "Skins2All_menu_forced_update_callback",
		title = "Skins2All_menu_forced_update_officially_title",
		desc = "Skins2All_menu_forced_update_officially_desc",
		callback = "Skins2All_menu_forced_update_callback",
		menu_id = "Skins2All_menu",
	})
	MenuHelper:AddButton({
		id = "Skins2All_menu_forced_update_all_callback",
		title = "Skins2All_menu_forced_update_all_title",
		desc = "Skins2All_menu_forced_update_all_desc",
		callback = "Skins2All_menu_forced_update_all_callback",
		menu_id = "Skins2All_menu",
	})
end)

Hooks:Add("MenuManagerBuildCustomMenus", "Skins2AllOptions", function(menu_manager, nodes)
	nodes["Skins2All_menu"] = MenuHelper:BuildMenu( "Skins2All_menu" )
	MenuHelper:AddMenuItem( MenuHelper.menus.lua_mod_options_menu, "Skins2All_menu", "Skins2All_menu_title", "Skins2All_menu_desc")
end)