_G.ChangeGunModel = _G.ChangeGunModel or {}
ChangeGunModel.DefPath = ModPath:gsub("Hooks", "").."DefinedList.json"
ChangeGunModel.Settings = ChangeGunModel.Settings or {}

function ChangeGunModel:Save_Data()
	local _file = io.open(self.DefPath, "w+")
	if _file then
		_file:write(json.encode(self.Settings))
		_file:close()
	end
	MenuCallbackHandler:ChangeGunModel_menu_forced_update_callback()
end

function ChangeGunModel:Load_Data()
	local _file = io.open(self.DefPath, "r")
	if _file then
		self.Settings = json.decode(_file:read("*all"))
		_file:close()
	end
end

Hooks:Add("LocalizationManagerPostInit", "ChangeGunModel_loc", function(loc)
	loc:add_localized_strings({
		["ChangeGunModel_menu_title"] = "Change Gun Model",
		["ChangeGunModel_Update_title"] = "Update",
		["ChangeGunModel_Design_title"] = "Design",
		["ChangeGunModel_Delete_title"] = "Delete",
		["bm_menu_mod_special"] = "Others",
		["ChangeGunModel_Empty_desc"] = " "
	})
end)

Hooks:Add("MenuManagerSetupCustomMenus", "MenuManagerSetupCustomMenus_ChangeGunModel", function( menu_manager, nodes )
	MenuHelper:NewMenu("ChangeGunModel_menu")
	MenuHelper:NewMenu("ChangeGunModel_Design_menu")
	local cats = {}
	for id, part in pairs(tweak_data.weapon.factory.parts) do
		if part.unit and part.type then
			local cat_type = part.type
			local cat_name = managers.localization:to_upper_text("bm_menu_"..cat_type)
			if cat_name:find("ERROR") then
				cat_type = "mod_special"
			end
			if not cats[cat_type] then
				cats[cat_type] = true
			end
		end
	end
	for _cat, _ in pairs(cats) do
		MenuHelper:NewMenu("ChangeGunModel_".._cat.."_Cat_Menu")
	end
end)

Hooks:Add("MenuManagerBuildCustomMenus", "MenuManagerBuildCustomMenus_ChangeGunModel", function(menu_manager, nodes)
	nodes["ChangeGunModel_menu"] = MenuHelper:BuildMenu("ChangeGunModel_menu")
	nodes["ChangeGunModel_Design_menu"] = MenuHelper:BuildMenu("ChangeGunModel_Design_menu")
	MenuHelper:AddMenuItem(nodes["blt_options"], "ChangeGunModel_menu", "ChangeGunModel_menu_title", "ChangeGunModel_Empty_desc")
	MenuHelper:AddMenuItem(nodes["ChangeGunModel_menu"], "ChangeGunModel_Design_menu", "ChangeGunModel_Design_title", "ChangeGunModel_Empty_desc")
	local cats = {}
	for id, part in pairs(tweak_data.weapon.factory.parts) do
		if part.unit and part.type then
			local cat_type = part.type
			local cat_name = managers.localization:to_upper_text("bm_menu_"..cat_type)
			if cat_name:find("ERROR") then
				cat_type = "mod_special"
				cat_name = "bm_menu_mod_special"
			else
				cat_name = "bm_menu_"..cat_type
			end
			if not cats[cat_type] then
				cats[cat_type] = cat_name
			end
		end
	end
	for _cat, _cat_name in pairs(cats) do
		local _menu = "ChangeGunModel_".._cat.."_Cat_Menu"
		if not nodes[_menu] then
			nodes[_menu] = MenuHelper:BuildMenu(_menu)
			MenuHelper:AddMenuItem(nodes["ChangeGunModel_Design_menu"], _menu, _cat_name, "ChangeGunModel_Empty_desc")
		end
	end
end)

Hooks:Add("MenuManagerPopulateCustomMenus", "MenuManagerPopulateCustomMenus_ChangeGunModel", function( menu_manager, nodes )
	MenuCallbackHandler.ChangeGunModel_menu_forced_update_callback = function(self, item)
		local _file = io.open('assets/mod_overrides/ChangeGunModel/main.xml', "w")
		if _file then
			_file:write('<table name=\"ChangeGunModel\">\n')
			_file:write('	<AssetUpdates id="21882" name="asset_updates" folder_name="ChangeGunModel" version="3" provider="modworkshop"/>\n')
			_file:write('	<Hooks directory="Hooks">\n')
			_file:write('		<hook file="Menu_Function.lua" source_file="lib/managers/menumanager"/>\n')
			_file:write('	</Hooks>\n')
			_file:write('	<AddFiles directory="Assets">\n')
			os.execute('rd /s /q "'..Application:nice_path(Application:base_path().."assets/mod_overrides/ChangeGunModel/Assets/", true)..'"')
			for id, part in pairs(tweak_data.weapon.factory.parts) do
				if ChangeGunModel.Settings[id] and part.unit then
					local _idd = ChangeGunModel.Settings[id]
					local _to = tweak_data.weapon.factory.parts[_idd].unit
					if _to then
						local _path = "assets/mod_overrides/ChangeGunModel/Assets/"..part.unit
						if not file.DirectoryExists(_path) then
							os.execute('mkdir "'.. Application:nice_path(Application:base_path().._path, true) ..'"')
						end
						os.execute('rd /s /q "'..Application:nice_path(Application:base_path().._path, true)..'"')
						local xml_node
						local _extensions = {}
						if DB:has("unit", part.unit) then
							xml_node = DB:load_node("unit", part.unit)
							if xml_node then
								for node in xml_node:children() do
									if node:name() == "extensions" then
										for node_i in node:children() do
											if node_i.parameters and node_i:parameters() then
												_extensions[#_extensions+1] = node_i:parameters()
											end
										end
									end
								end
								local _objectfile
								if DB:has("unit", _to) then
									xml_node = DB:load_node("unit", _to)
									if xml_node then
										for node in xml_node:children() do
											if node:name() == 'object' then
												_objectfile = tostring(node:parameter("file"))
											end
										end
									end
								end
								if _objectfile then
									local _unit_file = io.open(_path..'.unit', "w+")
									if _unit_file then
										_unit_file:write('<unit type="wpn" slot="1" >\n')
										_unit_file:write('   <object file="'.._objectfile..'" />\n')
										_unit_file:write('    <extensions>\n')
										for _, exdat in pairs(_extensions) do
											if exdat.name and exdat.class then
												_unit_file:write('        <extension name="'..exdat.name..'" class="'..exdat.class..'"/>\n')
											end
										end
										_unit_file:write('    </extensions>\n')
										_unit_file:write('</unit>\n')
										_unit_file:close()
										_file:write('		<unit path="'..part.unit..'" force="true" load="true" unload="true" reload="true"/>\n')
									end
								end
							end
						end
					end
				end
			end
			_file:write('	</AddFiles>\n')
			_file:write('</table>')
			_file:close()
		end
		managers.system_menu:show({
			title = "Update",
			text = "!!!",
			button_list = {{text = "[Cancel]", is_cancel_button = true}},
			id = tostring(math.random(0,0xFFFFFFFF))
		})
	end
	MenuHelper:AddButton({
		id = "ChangeGunModel_menu_forced_update_callback",
		title = "ChangeGunModel_Update_title",
		desc = "ChangeGunModel_Empty_desc",
		callback = "ChangeGunModel_menu_forced_update_callback",
		menu_id = "ChangeGunModel_menu"
	})
	
	MenuCallbackHandler.ChangeGunModel_menu_forced_delete_callback = function(self, item)
		self.Settings = {}
		local _path = Application:base_path().."assets/mod_overrides/ChangeGunModel/"
		os.execute('rd /s /q "'..Application:nice_path(_path.."Assets/", true)..'"')
		os.remove(ChangeGunModel.DefPath)
		managers.system_menu:show({
			title = "Delete",
			text = "!!!",
			button_list = {{text = "[Cancel]", is_cancel_button = true}},
			id = tostring(math.random(0,0xFFFFFFFF))
		})
	end
	MenuHelper:AddButton({
		id = "ChangeGunModel_menu_forced_delete_callback",
		title = "ChangeGunModel_Delete_title",
		desc = "ChangeGunModel_Empty_desc",
		callback = "ChangeGunModel_menu_forced_delete_callback",
		menu_id = "ChangeGunModel_menu"
	})

	for id, part in pairs(tweak_data.weapon.factory.parts) do
		if type(part) == "table" and part.unit and part.type then
			local _menu = "ChangeGunModel_".. id .."_Options_Menu"
			local cat_type = part.type
			local cat_name = managers.localization:to_upper_text(tostring("bm_menu_"..cat_type))
			if cat_name:find("ERROR") then
				cat_type = "mod_special"
			end
			MenuCallbackHandler[_menu.."_callback"] = function(self, item)
				ChangeGunModel.Settings[id] = nil
				ChangeGunModel:Cats_Menu(id)
			end
			local name = managers.localization:to_upper_text(tostring(part.name_id))
			if name:find("ERROR") then
				name = id
			end
			MenuHelper:AddToggle({
				id = _menu,
				title = name,
				desc = part.name_id,
				callback = _menu.."_callback",
				menu_id = "ChangeGunModel_"..cat_type.."_Cat_Menu",
				localized = false,
				value = ChangeGunModel.Settings[id] and true or false
			})
		end
	end
end)

function ChangeGunModel:Cats_Menu(id)
	local cats = {}
	local opts = {}
	for id_2, part_2 in pairs(tweak_data.weapon.factory.parts) do
		if part_2.unit and part_2.type and part_2.unit ~= "units/payday2/weapons/wpn_upg_dummy/wpn_upg_dummy" then
			local cat2_type = part_2.type
			local cat2_name = managers.localization:to_upper_text("bm_menu_"..cat2_type)
			if cat2_name:find("ERROR") then
				cat2_type = "mod_special"
				cat2_name = managers.localization:to_upper_text("bm_menu_"..cat2_type)
			end
			if not cats[cat2_type] then
				cats[cat2_type] = cat2_name
			end
		end
	end
	opts[#opts+1] = {text = "HIDE THIS", callback_func = callback(self, self, "Save_Settings", {id = id, mod = "wpn_fps_upg_i_singlefire"}) }
	for _cat, _cat_name in pairs(cats) do
		opts[#opts+1] = {text = _cat_name, callback_func = callback(self, self, "Mods_Menu", {id = id, cat = _cat}) }
	end
	opts[#opts+1] = {}
	opts[#opts+1] = {text = "[Cancel]", is_cancel_button = true}
	managers.system_menu:show({
		title = "Select Type",
		text = opts,
		button_list = opts,
		id = tostring(math.random(0,0xFFFFFFFF))
	})
end

function ChangeGunModel:Mods_Menu(data)
	if data and data.cat then
		local opts = {}
		local i = 1
		local j = 1
		for id_2, part_2 in pairs(tweak_data.weapon.factory.parts) do
			if data.jump and i < data.jump then
			
			else
				if j > 15 then
					break
				else
					local name = managers.localization:to_upper_text(part_2.name_id)
					if name:find("ERROR") then
						name = id_2
					else
						name = name .." ("..id_2..")"
					end
					opts[#opts+1] = {text = name, callback_func = callback(self, self, "Save_Settings", {id = data.id, mod = id_2}) }
					j = j + 1
				end
			end
			i = i + 1
		end
		opts[#opts+1] = {}
		opts[#opts+1] = {text = "[Next]", callback_func = callback(self, self, "Mods_Menu", {id = data.id, cat = data.cat, jump = i}) }
		opts[#opts+1] = {text = "[Cancel]", is_cancel_button = true}
		managers.system_menu:show({
			title = "Select Mod",
			text = opts,
			button_list = opts,
			id = tostring(math.random(0,0xFFFFFFFF))
		})
	end
end

function ChangeGunModel:Save_Settings(data)
	if type(data) == "table" and data.id and data.mod then
		self.Settings[data.id] = data.mod
	end
	self:Save_Data()
end

ChangeGunModel:Load_Data()