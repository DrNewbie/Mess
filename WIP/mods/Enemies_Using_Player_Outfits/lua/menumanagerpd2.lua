local ThisModPath = ModPath

local is_gerenate = false

local __Name = function(__id)
	return "E_"..Idstring(string.format('%q %q', tostring(__id), ThisModPath)):key()
end

local ThisModName = __Name("Enemies_Using_Player_Outfits")

_G[ThisModName] = _G[ThisModName] or {}

if _G[ThisModName].Init then
	return
end

_G[ThisModName].Init = true

_G[ThisModName].RunFinish = false

_G[ThisModName].ThisModPath = ThisModPath

_G[ThisModName].ThisModSubMenuPath = _G[ThisModName].ThisModPath.."/menu/"

_G[ThisModName].ThisModSavePath = _G[ThisModName].ThisModPath.."/__savefile.json"

_G[ThisModName].ThisModMenuSave = {true}

_G[ThisModName].Menu_ID = __Name("Menu_ID")

_G[ThisModName].Possible_Enemies_List = {}

_G[ThisModName].Possible_Player_Styles = {}

_G[ThisModName].__Save = function(this_path)
	pcall(io.save_as_json, _G[ThisModName].ThisModMenuSave, _G[ThisModName].ThisModSavePath)
	return
end

_G[ThisModName].__Load = function()
	local res, info
	if io.file_is_readable(_G[ThisModName].ThisModSavePath) then
		res, info = pcall(io.load_as_json, _G[ThisModName].ThisModSavePath)
	end
	if res and type(info) == "table" then
		_G[ThisModName].ThisModMenuSave = info
	else
		_G[ThisModName].ThisModMenuSave = {true}
		_G[ThisModName].__Save()
	end
	return
end

_G[ThisModName].__Load()

Hooks:Add("LocalizationManagerPostInit", __Name("LocalizationManagerPostInit"), function(self)
	self:load_localization_file(ThisModPath.."loc/EN.json", false)
end)

Hooks:Add("MenuManagerSetupCustomMenus", __Name("MenuManagerSetupCustomMenus"), function(menu_manager, nodes)
	MenuHelper:NewMenu(_G[ThisModName].Menu_ID)
	nodes[_G[ThisModName].Menu_ID] = MenuHelper:BuildMenu(_G[ThisModName].Menu_ID)
	MenuHelper:AddMenuItem(nodes["blt_options"], _G[ThisModName].Menu_ID, "EUPOsss_menu_title", "EUPOsss_menu_desc")
	
	local char_map = tweak_data.character.character_map()
	local Block = {
		ene_female_civ_undercover = true
	}
	
	local player_styles = tweak_data.blackmarket.player_styles
	for player_style_name, player_style_data in pairs(player_styles) do
		if type(player_style_name) == "string" and type(player_style_data) == "table" and type(player_style_data.name_id) == "string" then
			_G[ThisModName].Possible_Player_Styles[player_style_name] = player_style_data
		end
	end
	
	for _, __table in pairs(char_map) do
		if type(__table) == "table" and type(__table.path) == "string" and type(__table.list) == "table" then
			for _, __u_name in pairs(__table.list) do
				__u_name = tostring(__u_name)
				local unit_dir = __table.path .. __u_name
				local unit_path = __table.path .. __u_name .. "/" .. __u_name
				unit_path = tostring(unit_path)
				local u_key = Idstring(unit_path):key()
				if not Block[__u_name] and not _G[ThisModName].Possible_Enemies_List[u_key] then
					if not string.find(__u_name, "female") and not string.find(__u_name, "civ") and not string.find(__u_name, "npc") and DB:has("unit", unit_path) and DB:has("object", unit_path) then
						_G[ThisModName].Possible_Enemies_List[u_key] = unit_path
						local sp_menu = __Name("Enemies_"..u_key.."_Options_Menu")
						local sp_menu_title = __Name("Enemies_"..u_key.."_Options_Menu_Name")
						local sp_menu_desc = __Name("Enemies_"..u_key.."_Options_Menu_Desc")
						managers.localization:add_localized_strings({
							[sp_menu_title] = __u_name,
							[sp_menu_desc] = unit_path,
						})
						--MenuHelper:NewMenu(sp_menu)
						
						local NewSubMenu = {
							["menu_id"] = sp_menu,
							["parent_menu_id"] = _G[ThisModName].Menu_ID,
							["title"] = sp_menu_title,
							["description"] = sp_menu_desc,
							["items"] = {}
						}

						for player_style_name, player_style_data in pairs(_G[ThisModName].Possible_Player_Styles) do
							_G[ThisModName].ThisModMenuSave[u_key] = _G[ThisModName].ThisModMenuSave[u_key] or {}
							
							local sp_menu_toggle = __Name("Enemies_"..u_key.."_Options_Menu_Player_Styles_Toggle_"..player_style_name)
							local sp_menu_toggle_callback = __Name("Enemies_"..u_key.."_Options_Menu_Player_Styles_Toggle_Callback_"..player_style_name)

							MenuCallbackHandler[sp_menu_toggle_callback] = function(them, this_item)
								if tostring(this_item:value()) == "on" then
									_G[ThisModName].ThisModMenuSave[u_key][player_style_name] = 1
								else
									_G[ThisModName].ThisModMenuSave[u_key][player_style_name] = 0
								end
								DelayedCalls:Add(__Name("delay to save"), 1, _G[ThisModName].__Save)
							end

							_G[ThisModName].ThisModMenuSave[u_key][player_style_name] = _G[ThisModName].ThisModMenuSave[u_key][player_style_name] or 0	

							table.insert(NewSubMenu.items, {
								["type"] = "toggle",
								["id"] = sp_menu_toggle,
								["title"] = tostring(player_style_data.name_id),
								--["description"] = tostring(player_style_data.desc_id),
								["callback"] = sp_menu_toggle_callback,
								["value"] = false,
								["default_value"] = false
							})
						end
						if is_gerenate then
							if io.file_is_readable(_G[ThisModName].ThisModSubMenuPath.."sub_menu_"..u_key..".json") then
								os.remove(_G[ThisModName].ThisModSubMenuPath.."sub_menu_"..u_key..".json")
							end
							pcall(io.save_as_json, NewSubMenu, _G[ThisModName].ThisModSubMenuPath.."sub_menu_"..u_key..".json")
						end
						
						MenuHelper:LoadFromJsonFile(_G[ThisModName].ThisModSubMenuPath.."sub_menu_"..u_key..".json", _G[ThisModName], _G[ThisModName].ThisModMenuSave)
					end
				end
			end
		end
	end
	
	_G[ThisModName].RunFinish = true
end)

local __dely_run = function()
	local already_load = {}
	if _G[ThisModName].RunFinish then
		for u_key, _ in pairs(_G[ThisModName].Possible_Enemies_List) do
			local sp_menu = __Name("Enemies_"..u_key.."_Options_Menu")
			local this_menu_data = MenuHelper:GetMenu(sp_menu)
			if this_menu_data then
				_G[ThisModName].ThisModMenuSave[u_key] = _G[ThisModName].ThisModMenuSave[u_key] or {}
				for player_style_name, _ in pairs(_G[ThisModName].Possible_Player_Styles) do
					_G[ThisModName].ThisModMenuSave[u_key][player_style_name] = _G[ThisModName].ThisModMenuSave[u_key][player_style_name] or 0
					local sp_menu_toggle = __Name("Enemies_"..u_key.."_Options_Menu_Player_Styles_Toggle_"..player_style_name)
					for item_name, item_data in pairs(this_menu_data._items) do
						if type(item_data) == "table" and type(item_data._parameters) == "table" and type(item_data._parameters.name) == "string" and item_data._parameters.name == sp_menu_toggle and type(item_data.set_value) == "function" then
							local ans = tonumber(tostring(_G[ThisModName].ThisModMenuSave[u_key][player_style_name]))							
							item_data:set_value(ans == 1 and "on" or "off")
							if ans == 1 then
								local player_style_unit_name = tweak_data.blackmarket:get_player_style_value(player_style_name, "dallas", "third_unit")
								if managers.dyn_resource:is_resource_ready(Idstring("unit"), Idstring(player_style_unit_name), managers.dyn_resource.DYN_RESOURCES_PACKAGE) then
								
								else
									if not already_load[player_style_name] then
										already_load[player_style_name] = true
										managers.dyn_resource:load(Idstring("unit"), Idstring(player_style_unit_name), DynamicResourceManager.DYN_RESOURCES_PACKAGE)
									end
								end
							end
							break
						end
					end
				end
			end
		end
		_G[ThisModName].__Save()
		if is_gerenate then
			pcall(function()
				local __main_xml = io.open(ThisModPath..'/supermod.xml', "w+")
				local __attach_line = [[
	<target mode="attach">
		<extension name="spawn_manager" class="ManageSpawnedUnits" >
			<var name="is_cop" value="true"/>
			<var name="_char_joint_names" type="table" >
				<var value="root_point" />
				<var value="Hips" />
				<var value="Spine" />
				<var value="Spine1" />
				<var value="Spine2" />
				<var value="Neck" />
				<var value="Head" />
				
				<var value="LeftShoulder" />
				<var value="LeftArm" />
				<var value="LeftForeArmRoll" />
				<var value="LeftForeArm" />
				<var value="LeftHand" />

				<var value="LeftHandThumb1" />
				<var value="LeftHandThumb2" />
				<var value="LeftHandThumb3" />

				<var value="LeftHandIndex1" />
				<var value="LeftHandIndex2" />
				<var value="LeftHandIndex3" />

				<var value="LeftHandMiddle1" />
				<var value="LeftHandMiddle2" />
				<var value="LeftHandMiddle3" />

				<var value="LeftHandRing1" />
				<var value="LeftHandRing2" />
				<var value="LeftHandRing3" />

				<var value="LeftHandPinky1" />
				<var value="LeftHandPinky2" />
				<var value="LeftHandPinky3" />

				<var value="RightShoulder" />
				<var value="RightArm" />
				<var value="RightForeArmRoll" />
				<var value="RightForeArm" />
				<var value="RightHand" />

				<var value="RightHandThumb1" />
				<var value="RightHandThumb2" />
				<var value="RightHandThumb3" />

				<var value="RightHandIndex1" />
				<var value="RightHandIndex2" />
				<var value="RightHandIndex3" />

				<var value="RightHandMiddle1" />
				<var value="RightHandMiddle2" />
				<var value="RightHandMiddle3" />

				<var value="RightHandRing1" />
				<var value="RightHandRing2" />
				<var value="RightHandRing3" />

				<var value="RightHandPinky1" />
				<var value="RightHandPinky2" />
				<var value="RightHandPinky3" />

				<var value="LeftUpLeg" />
				<var value="LeftLeg" />
				<var value="LeftFoot" />
				<var value="LeftToeBase" />

				<var value="RightUpLeg" />
				<var value="RightLeg" />
				<var value="RightFoot" />
				<var value="RightToeBase" />
			</var>
			<var name="allow_client_spawn" value="true"/>
			<var name="local_only" value="true"/>
		</extension>
	</target>
]]
				if __main_xml then
					__main_xml:write('<?xml version="1.0" encoding="utf-8"?>\n')
					__main_xml:write('<mod name="Enemies_Using_Player_Outfits" global_key="Enemies_Using_Player_Outfits">\n')
					local Possible_Enemies_List = _G[ThisModName].Possible_Enemies_List
					for u_key, unit_path in pairs(Possible_Enemies_List) do
						local __o_xml = DB:open("unit", unit_path):read()
						if not __o_xml:find("spawn_manager") and not __o_xml:find("CivilianBase") then
							__main_xml:write('	<tweak definition="xml/'..u_key..'.xml"/>\n')
							if io.file_is_readable(ThisModPath..'/xml/'..u_key..'.xml') then
								os.remove(ThisModPath..'/xml/'..u_key..'.xml')
							end
							local __s_xml = io.open(ThisModPath..'/xml/'..u_key..'.xml', "w+")
							if __s_xml then
								__s_xml:write('<?xml version="1.0" encoding="utf-8"?>\n')
								__s_xml:write('<tweak version="2" name="'..unit_path..'" extension="unit">\n')
								__s_xml:write('	<search>\n')
								for __line in __o_xml:gmatch("([^\n]*)\n?") do
									if __line:find('xml version') then
										__s_xml:write('		'..__line..'\n')
										break
									end
									break
								end
								__s_xml:write('		<unit/>\n')
								__s_xml:write('		<extensions/>\n')
								__s_xml:write('	</search>\n')
								__s_xml:write(''..__attach_line..'\n')
								__s_xml:write('</tweak>\n')
								__s_xml:close()
							end
						end
					end
					__main_xml:write('</mod>\n')
					__main_xml:close()
				end
			end)
		end
	else
		DelayedCalls:Add(__Name("delay apply data to menu"), 1, __dely_run)
	end
	return
end

pcall(function()
	DelayedCalls:Add(__Name("delay apply data to menu"), 1, __dely_run)
end)