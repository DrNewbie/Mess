Hooks:Add("MenuManagerSetupCustomMenus", "MenuManagerSetupCustomMenus_Materials2Skins", function(menu_manager, nodes)
	MenuHelper:NewMenu("Materials2Skins_menu_id")
end)

Hooks:Add("MenuManagerPopulateCustomMenus", "MenuManagerPopulateCustomMenus_Materials2Skins", function(menu_manager, nodes)
	MenuCallbackHandler.Materials2Skins_Update_Callback = function(self, item)
		QuickMenu:new(
			"Materials to Skins",
			"All data is updated",
			{{"Ok", is_cancel_button = true}},
			true
		):Show()
		local _file = io.open('mods/Materials2Skins/lua/armorskinstweakdata.lua', "w+")
		_file:write('Hooks:PostHook(EconomyTweakData, "_init_armor_skins", "AddNewArmorSkins_Materials2Skins", function(self, ...)\n')
		for _id, _data in pairs(tweak_data.blackmarket.materials) do
			local _newskinsname = 'materials_' .. _id
			if _data.name_id and _data.texture then
				_file:write('	self.armor_skins.'.. _newskinsname ..' = {}\n')
				_file:write('	self.armor_skins.'.. _newskinsname ..'.name_id = "'.. _data.name_id ..'"\n')
				_file:write('	self.armor_skins.'.. _newskinsname ..'.desc_id = "bm_askn_none_desc"\n')
				_file:write('	self.armor_skins.'.. _newskinsname ..'.rarity = "uncommon"\n')
				_file:write('	self.armor_skins.'.. _newskinsname ..'.reserve_quality = false\n')
				_file:write('	self.armor_skins.'.. _newskinsname ..'.steam_economy = false\n')
				_file:write('	self.armor_skins.'.. _newskinsname ..'.free = true\n')
				_file:write('	self.armor_skins.'.. _newskinsname ..'.unlocked = true\n')
				_file:write('	self.armor_skins.'.. _newskinsname ..'.texture_bundle_folder = "cash/safes/cvc"\n')
				_file:write('	self.armor_skins.'.. _newskinsname ..'.base_gradient = Idstring("'.. _data.texture ..'")\n')
				_file:write('	self.armor_skins.'.. _newskinsname ..'.sticker = nil\n')
				_file:write('	self.armor_skins.'.. _newskinsname ..'.uv_scale = Vector3(1, 1, 1)\n')
				_file:write('	self.armor_skins.'.. _newskinsname ..'.uv_offset_rot = Vector3(-0.001, 0.994791, 0)\n')
				_file:write('	self.armor_skins.'.. _newskinsname ..'.cubemap_pattern_control = Vector3(0, 0.001, 0)\n')
			end
		end
		_file:write('end)\n')
		_file:close()
	end
	MenuHelper:AddButton({
		id = "Materials2Skins_Update_Callback",
		title = "menu_Materials2Skins_button_name",
		desc = "menu_Materials2Skins_button_desc",
		callback = "Materials2Skins_Update_Callback",
		menu_id = "Materials2Skins_menu_id",
	})
end)

Hooks:Add("MenuManagerBuildCustomMenus", "MenuManagerBuildCustomMenus_Materials2Skins", function(menu_manager, nodes)
	nodes["Materials2Skins_menu_id"] = MenuHelper:BuildMenu("Materials2Skins_menu_id")
	MenuHelper:AddMenuItem(nodes["blt_options"], "Materials2Skins_menu_id", "menu_Materials2Skins_contract_name", "menu_Materials2Skins_contract_desc")
end)

Hooks:Add("LocalizationManagerPostInit", "Materials2Skins_loc", function(loc)
	LocalizationManager:add_localized_strings({
		["menu_Materials2Skins_contract_name"] = "Materials to Skins",
		["menu_Materials2Skins_contract_desc"] = "...",
		["menu_Materials2Skins_button_name"] = "Update",
		["menu_Materials2Skins_button_desc"] = "..."
	})
end)