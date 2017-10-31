_G.MutatorRandomizer_Data = _G.MutatorRandomizer_Data or {}
MutatorRandomizer_Data.ModPath = ModPath
MutatorRandomizer_Data.SaveFile = MutatorRandomizer_Data.SaveFile or SavePath .. "Randomizer.txt"
MutatorRandomizer_Data.DataPath = MutatorRandomizer_Data.ModPath .. "Randomizer.txt"
MutatorRandomizer_Data.menu_id = "MutatorRandomizer_menu_id"
MutatorRandomizer_Data.Possible_Data = {}
MutatorRandomizer_Data.Possible_Data_Size = 30
MutatorRandomizer_Data.Selected_Data = {
	character = "",
	primary = "",
	primary_mods = {},
	secondary = "",
	secondary_mods = {},
	armor = "",
	deployable = "",
	throwable = "",
	melee = ""
}
MutatorRandomizer_Data.Selected_Toggle = {
	Character = false,
	Primary = true,
	Secondary = true,
	Armor = true,
	Deployable = true,
	Throwable = true,
	Melee = true,
	DoesItemUnlock = true,
	PartsCrazyTry = false
}

function MutatorRandomizer_Data:Selected_Toggle_Reset()
	self.Selected_Toggle = {
		Character = false,
		Primary = true,
		Secondary = true,
		Armor = true,
		Deployable = true,
		Throwable = true,
		Melee = true,
		DoesItemUnlock = true,
		PartsCrazyTry = false
	}
	self:Selected_Toggle_Save()
end

function MutatorRandomizer_Data:Selected_Toggle_Load(supp, current_stage)
	local _file = io.open(self.SaveFile, "r")
	if _file then
		self.Selected_Toggle = json.decode(_file:read("*all"))
		_file:close()
		self:Selected_Toggle_Save()
	end
end

function MutatorRandomizer_Data:Selected_Toggle_Save()
	local _file = io.open(self.SaveFile, "w+")
	if _file then
		_file:write(json.encode(self.Selected_Toggle))
		_file:close()
	else
		self:Selected_Toggle_Reset()
	end
end


Hooks:Add("MenuManagerSetupCustomMenus", "MenuManagerSetupCustomMenus_MutatorRandomizer_Data", function(menu_manager, nodes)
	MenuHelper:NewMenu(MutatorRandomizer_Data.menu_id)
end)

Hooks:Add("MenuManagerPopulateCustomMenus", "MenuManagerPopulateCustomMenus_MutatorRandomizer_Data", function(menu_manager, nodes)
	local _bool = true
	local _id = ""
	local _priority = 0
	for k, _ in pairs(MutatorRandomizer_Data.Selected_Toggle) do
		_id = "MutatorRandomizer_EachMenu_" .. k
		_priority = _priority + 1
		MenuCallbackHandler[_id] = function(self, item)
			MutatorRandomizer_Data.Selected_Toggle[k] = tostring(item:value()) == "on" and true or false
			MutatorRandomizer_Data:Selected_Toggle_Save()
		end
		_bool = MutatorRandomizer_Data.Selected_Toggle[k] == true and true or false
		MenuHelper:AddToggle({
			id = _id,
			title = "menu_MutatorRandomizer_Data_".. k .."_name",
			desc = "menu_MutatorRandomizer_Data_nah",
			callback = _id,
			value = _bool,
			menu_id = MutatorRandomizer_Data.menu_id,
			priority = _priority
		})
	end
	MenuCallbackHandler.menu_MutatorRandomizer_Data_Clean = function(self, item)
		os.remove(MutatorRandomizer_Data.SaveFile)
		os.remove(MutatorRandomizer_Data.DataPath)
		local _dialog_data = {
			title = "[Randomizer]",
			text = "Finish",
			button_list = {{ text = "[OK]", is_cancel_button = true }},
			id = tostring(math.random(0,0xFFFFFFFF))
		}
		managers.system_menu:show(_dialog_data)
	end
	MenuHelper:AddButton({
		id = "menu_MutatorRandomizer_Data_Clean",
		title = "menu_MutatorRandomizer_Data_CLEAN_name",
		desc = "menu_MutatorRandomizer_Data_nah",
		callback = "menu_MutatorRandomizer_Data_Clean",
		menu_id = MutatorRandomizer_Data.menu_id,
		priority = 1000
	})
end)

Hooks:Add("MenuManagerBuildCustomMenus", "MenuManagerBuildCustomMenus_MutatorRandomizer_Data", function(menu_manager, nodes)
	nodes[MutatorRandomizer_Data.menu_id] = MenuHelper:BuildMenu(MutatorRandomizer_Data.menu_id)
	MenuHelper:AddMenuItem(nodes["blt_options"], MutatorRandomizer_Data.menu_id, "menu_MutatorRandomizer_Data_Randomizer_name", "menu_MutatorRandomizer_Data_Randomizer_decs")
end)

Hooks:Add("LocalizationManagerPostInit", "MutatorRandomizer_Data_loc", function(loc)
	loc:load_localization_file(MutatorRandomizer_Data.ModPath .. "loc/loc.txt")
end)

MutatorRandomizer_Data:Selected_Toggle_Load()

function MutatorRandomizer_Data:Data_Generator()
	local _size = self.Possible_Data_Size
	if not tweak_data or not tweak_data.statistics or not tweak_data.weapon or not tweak_data.weapon.factory or not managers.weapon_factory then
		return
	end
	local _, _, _, _weapon_list, _melee_list, _grenade_list, _, _armor_list, _character_list, _deployable_list = tweak_data.statistics:statistics_table()
	if Global.blackmarket_manager then
		local _tmp_list1 = {
			_grenade_list = {},
			_melee_list = {},
			_character_list = {},
			_weapon_list = {},
		}
		local _tmp_list2 = {
			grenades = '_grenade_list',
			melee_weapons = '_melee_list',
			characters = '_character_list',
			weapons = '_weapon_list'
		}
		local _isDoesItemUnlock = self.Selected_Toggle["DoesItemUnlock"]
		if _isDoesItemUnlock then
			for _id, _table_name in pairs(_tmp_list2) do
				if Global.blackmarket_manager[_id] then
					for _in_id, _in_data in pairs(Global.blackmarket_manager[_id]) do
						if _isDoesItemUnlock and _in_data.unlocked then
							table.insert(_tmp_list1[_table_name], _in_id)
						end
					end
				end
				_grenade_list = _tmp_list1["_grenade_list"]
				_melee_list = _tmp_list1["_melee_list"]
				_character_list = _tmp_list1["_character_list"]
				_weapon_list = _tmp_list1["_weapon_list"]
			end
		end
	end
	local _primary, _secondary = {}, {}
	for _, _name in pairs(_weapon_list) do
		if tweak_data.weapon[_name] and tweak_data.weapon[_name].use_data then
			if tweak_data.weapon[_name].use_data.selection_index == 2 then
				table.insert(_primary, _name)
			elseif tweak_data.weapon[_name].use_data.selection_index == 1 then
				table.insert(_secondary, _name)
			end
		end
	end
	local _data_ready = {}
	for i = 1, _size do
		local _primary_selected = _primary[math.random(#_primary)]
		local _secondary_selected = _secondary[math.random(#_secondary)]
		local _primary_selected_factory_id = managers.weapon_factory:get_factory_id_by_weapon_id(_primary_selected)
		local _secondary_selectedfactory_id = managers.weapon_factory:get_factory_id_by_weapon_id(_secondary_selected)
		local _tweak_data_factory = tweak_data.weapon.factory
		if not _tweak_data_factory[_primary_selected_factory_id] then
			return
		end
		local _primary_selected_factory_data = _tweak_data_factory[_primary_selected_factory_id].uses_parts
		if not _tweak_data_factory[_secondary_selectedfactory_id] then
			return
		end
		local _secondary_selected_factory_data = _tweak_data_factory[_secondary_selectedfactory_id].uses_parts
		local _primary_mods, _secondary_mods, _used = {}, {}, {}
		local _added = 0		
		for _, _factory_name in pairs(_primary_selected_factory_data) do
			if _added >= #_primary_selected_factory_data then
				break
			end
			local _dd = _primary_selected_factory_data[math.random(#_primary_selected_factory_data)]
			local _tt = _tweak_data_factory.parts[_dd].type
			local _aa = _tweak_data_factory.parts[_dd].a_obj
			if self.Selected_Toggle["PartsCrazyTry"] then
				_aa = nil
			end
			if not _tweak_data_factory.parts[_dd].dlc or not managers.dlc:is_dlc_unlocked(_tweak_data_factory.parts[_dd].dlc) then
				if not _used[_tt] and ((_aa and not _used[_aa]) or not _aa) then
					_used[_tt] = true
					_used[_aa] = true
					_primary_mods[#_primary_mods+1] = _dd
				end
			end
			_added = _added + 1
		end
		_used = {}
		_added = 0
		for _, _factory_name in pairs(_secondary_selected_factory_data) do
			if _added >= #_secondary_selected_factory_data then
				break
			end
			local _dd = _secondary_selected_factory_data[math.random(#_secondary_selected_factory_data)]
			local _tt = _tweak_data_factory.parts[_dd].type
			local _aa = _tweak_data_factory.parts[_dd].a_obj
			if self.Selected_Toggle["PartsCrazyTry"] then
				_aa = nil
			end
			if not _tweak_data_factory.parts[_dd].dlc or not managers.dlc:is_dlc_unlocked(_tweak_data_factory.parts[_dd].dlc) then
				if not _used[_tt] and ((_aa and not _used[_aa]) or not _aa) then
					_used[_tt] = true
					_used[_aa] = true
					_secondary_mods[#_secondary_mods+1] = _dd
				end
			end
			_added = _added + 1
		end
		local _armor_selected = _armor_list[math.random(#_armor_list)]
		local _deployable_selected = _deployable_list[math.random(#_deployable_list)]
		local _grenade_selected = _grenade_list[math.random(#_grenade_list)]
		local _melee_selected = _melee_list[math.random(#_melee_list)]
		local _character_selected = _character_list[math.random(#_character_list)]
		_data_ready[i] = {
			character = _character_selected,
			primary = _primary_selected_factory_id,
			primary_mods = _primary_mods,
			secondary = _secondary_selectedfactory_id,
			secondary_mods = _secondary_mods,
			armor = _armor_selected,
			deployable = _deployable_selected,
			throwable = _grenade_selected,
			melee = _melee_selected
		}
	end
	local _file = io.open(self.DataPath, "w+")
	if _file then
		_file:write( json.encode( _data_ready ) )
		_file:close()
	end
	return _data_ready
end

Hooks:PostHook(BlackMarketManager, "_setup", "Randomizer_setup", function(bmm, ...)
	math.randomseed(tostring(os.time()):reverse():sub(1, 6))
	local _file = io.open(MutatorRandomizer_Data.DataPath, "r")
	if not _file then
		MutatorRandomizer_Data.Possible_Data = MutatorRandomizer_Data:Data_Generator()	
	else
		if math.random(1, 10) == 7 then
			MutatorRandomizer_Data:Data_Generator()
		end
		MutatorRandomizer_Data.Possible_Data = json.decode(_file:read("*all"))
		_file:close()
	end
	_file = nil
	if MutatorRandomizer_Data.Possible_Data then
		local _time_loops = 0
		local _selected = MutatorRandomizer_Data.Possible_Data[math.random(MutatorRandomizer_Data.Possible_Data_Size)]
		while _selected == tweak_data.levels[Global.game_settings.level_id].force_equipment do
			if _time_loops > 50 then
				break
			end
			_time_loops = _time_loops + 1
			_selected = MutatorRandomizer_Data.Possible_Data[math.random(MutatorRandomizer_Data.Possible_Data_Size)]
		end
		if _selected and Global.game_settings and Global.game_settings.level_id then			
			tweak_data.levels[Global.game_settings.level_id].force_equipment = _selected
			MutatorRandomizer_Data.Selected_Data = _selected
		end
	end
end)

local MutatorRandomizer_Data_forced_primary = BlackMarketManager.forced_primary
function BlackMarketManager:forced_primary(...)
	if not MutatorRandomizer_Data.Selected_Toggle["Primary"] then
		return
	end
	return MutatorRandomizer_Data_forced_primary(self, ...)
end

local MutatorRandomizer_Data_forced_secondary = BlackMarketManager.forced_secondary
function BlackMarketManager:forced_secondary(...)
	if not MutatorRandomizer_Data.Selected_Toggle["Secondary"] then
		return
	end
	return MutatorRandomizer_Data_forced_secondary(self, ...)
end

local MutatorRandomizer_Data_forced_armor = BlackMarketManager.forced_armor
function BlackMarketManager:forced_armor(...)
	if not MutatorRandomizer_Data.Selected_Toggle["Armor"] then
		return
	end
	return MutatorRandomizer_Data_forced_armor(self, ...)
end

local MutatorRandomizer_Data_forced_deployable = BlackMarketManager.forced_deployable
function BlackMarketManager:forced_deployable(...)
	if not MutatorRandomizer_Data.Selected_Toggle["Deployable"] then
		return
	end
	return MutatorRandomizer_Data_forced_deployable(self, ...)
end

local MutatorRandomizer_Data_forced_throwable = BlackMarketManager.forced_throwable
function BlackMarketManager:forced_throwable(...)
	if not MutatorRandomizer_Data.Selected_Toggle["Throwable"] then
		return
	end
	return MutatorRandomizer_Data_forced_throwable(self, ...)
end

function BlackMarketManager:forced_melee()
	if not MutatorRandomizer_Data.Selected_Toggle["Melee"] then
		return
	end
	local level_data = tweak_data.levels[managers.job:current_level_id()]
	return level_data and level_data.force_equipment and level_data.force_equipment.melee or nil
end

function BlackMarketManager:equipped_melee_weapon()
	local forced_melee = self:forced_melee()
	if forced_melee then
		return forced_melee
	end
	local melee_weapon
	for melee_weapon_id, data in pairs(tweak_data.blackmarket.melee_weapons) do
		melee_weapon = Global.blackmarket_manager.melee_weapons[melee_weapon_id]
		if melee_weapon.equipped and melee_weapon.unlocked then
			return melee_weapon_id
		end
	end
	self:aquire_default_weapons()
	return self._defaults.melee_weapon
end

function BlackMarketManager:forced_character()
	if not MutatorRandomizer_Data.Selected_Toggle["Character"] then
		return
	end
	if managers.network and managers.network:session() then
		local level_data = tweak_data.levels[managers.job:current_level_id()]
		if level_data and level_data.force_equipment then
			local peer = managers.network:session():local_peer()
			if peer and peer:character() ~= level_data.force_equipment.character then
				if managers.criminals:is_taken(level_data.force_equipment.character) then
					peer:set_character(managers.criminals:get_free_character_name())
				else
					peer:set_character(level_data.force_equipment.character)
				end
			end
			return level_data.force_equipment.character
		end
	end
end