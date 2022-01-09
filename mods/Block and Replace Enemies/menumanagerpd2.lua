_G.BoR_Enemy = _G.BoR_Enemy or {}
BoR_Enemy = BoR_Enemy or {}
BoR_Enemy.ModPath = BoR_Enemy.ModPath or ModPath
BoR_Enemy.settings = BoR_Enemy.settings or {}
BoR_Enemy.enemy_type_list = BoR_Enemy.enemy_type_list or {}
BoR_Enemy.type_enemy_list = BoR_Enemy.type_enemy_list or {}

function BoR_Enemy:Name(__name)
	return "BoR_E_"..Idstring(__name.."::"..self.ModPath):key()
end

local function __Name(__name)
	return BoR_Enemy:Name(__name)
end

BoR_Enemy.menu_id = __Name("menu_id")
BoR_Enemy.SaveFile = BoR_Enemy.SaveFile or SavePath..__Name("SaveFile")..".txt"

function BoR_Enemy:Reset()
	self.settings = {
		init = true
	}
	self:Save()
	return
end

function BoR_Enemy:Load()
	local __file = io.open(self.SaveFile, "r")
	if __file then
		for key, value in pairs(json.decode(__file:read("*all"))) do
			self.settings[key] = value
		end
		__file:close()
	else
		self:Reset()
	end
	return
end

function BoR_Enemy:Save()
	local __file = io.open(self.SaveFile, "w+")
	if __file then
		__file:write(json.encode(self.settings))
		__file:close()
	end
	return
end

function BoR_Enemy:Get_Value(__name)
	return self.settings[self:Name(__name)] or nil
end

function BoR_Enemy:Set_Value(__name, __var)
	self.settings[self:Name(__name)] = __var
	self:Save()
	return
end

local function __Get(__name)
	return BoR_Enemy:Get_Value(__name)
end

local function __Set(__name, __var)
	return BoR_Enemy:Set_Value(__name, __var)
end

BoR_Enemy:Load()

Hooks:Add("LocalizationManagerPostInit", __Name("Loc"), function(loc)
	loc:add_localized_strings({
		["BoR_Enemy_menu_title"] = "Block and Replace Enemies",
		["BoR_Enemy_menu_desc"] = " ",
		["BoR_Enemy_menu_opts_1"] = "Default",
		["BoR_Enemy_menu_opts_2"] = "Block",
		["BoR_Enemy_menu_opts_3"] = "Bulldozer",
		["BoR_Enemy_menu_opts_4"] = "Cloaker",
		["BoR_Enemy_menu_opts_5"] = "Shield",
		["BoR_Enemy_menu_opts_6"] = "Taser",
		["BoR_Enemy_menu_opts_7"] = "Medic",
		["BoR_Enemy_menu_opts_8"] = "Minigun-dozer",
		["BoR_Enemy_menu_opts_9"] = "Medic-dozer",
		["BoR_Enemy_menu_opts_10"] = "Bulldozer+",
		["BoR_Enemy_menu_opts_11"] = "Random"
	})
end)

Hooks:Add("MenuManagerSetupCustomMenus", __Name("NewMenu"), function()
	MenuHelper:NewMenu(BoR_Enemy.menu_id)
end)

Hooks:Add("MenuManagerPopulateCustomMenus", __Name("CustomMenus"), function(menu_manager, nodes)
	local __items = {
		"BoR_Enemy_menu_opts_1",
		"BoR_Enemy_menu_opts_2",
		"BoR_Enemy_menu_opts_3",
		"BoR_Enemy_menu_opts_4",
		"BoR_Enemy_menu_opts_5",
		"BoR_Enemy_menu_opts_6",
		"BoR_Enemy_menu_opts_7",
		"BoR_Enemy_menu_opts_8",
		"BoR_Enemy_menu_opts_9",
		"BoR_Enemy_menu_opts_10",
		"BoR_Enemy_menu_opts_11"
	}
	for __i = 3, 9 do
		MenuCallbackHandler[__Name("callback::"..__i)] = function(self, item)
			__Set("value::"..__i, math.floor(item:value()))
		end
		MenuHelper:AddMultipleChoice({
			id = __Name("id::"..__i),
			title = "BoR_Enemy_menu_opts_"..__i,
			callback = __Name("callback::"..__i),
			items = __items,
			value = __Get("value::"..__i) or 1,
			priority = 100-__i,
			menu_id = BoR_Enemy.menu_id,  
		})
	end
end)

Hooks:Add("MenuManagerBuildCustomMenus", __Name("BuildMenu"), function(menu_manager, nodes)
	nodes[BoR_Enemy.menu_id] = MenuHelper:BuildMenu(BoR_Enemy.menu_id)
	MenuHelper:AddMenuItem(nodes["blt_options"], BoR_Enemy.menu_id, "BoR_Enemy_menu_title", "BoR_Enemy_menu_desc")
end)

function BoR_Enemy:Get_TypeEnemy(__type)
	return self.type_enemy_list[__type]
end

function BoR_Enemy:Set_EnemyType(unit_name_ids, __type)
	self.enemy_type_list[unit_name_ids:key()] = __type
	self.type_enemy_list[__type] = self.type_enemy_list[__type] or {}
	self.type_enemy_list[__type][unit_name_ids:key()] = unit_name_ids
	return
end

function BoR_Enemy:Get_EnemyType(unit_name_ids)
	if self.enemy_type_list[unit_name_ids:key()] then
		return self.enemy_type_list[unit_name_ids:key()]
	end
	if DB:has(Idstring("unit"), unit_name_ids) then
		local unit_node = DB:load_node(Idstring("unit"), unit_name_ids)
		if unit_node and type(unit_node) == "userdata" then
			local unit_node_string = tostring(unit_node)
			local type_list = {
				["tank"] = 3,
				["spooc"] = 4,
				["shield"] = 5,
				["taser"] = 6,
				["medic"] = 7,
				["tank_medic"] = 8,
				["tank_mini"] = 9
			}
			for type_key, type_id in pairs(type_list) do
				if unit_node_string:find('<var name="_tweak_table" value="'..type_key..'"/>') then
					self:Set_EnemyType(unit_name_ids, type_id)
					return type_id
				end
			end
			self:Set_EnemyType(unit_name_ids, 999)
			return 999
		end
	end
	return -1
end

BoR_Enemy:Get_EnemyType("units/payday2/characters/ene_medic_r870/ene_medic_r870")
BoR_Enemy:Get_EnemyType("units/payday2/characters/ene_medic_m4/ene_medic_m4")
BoR_Enemy:Get_EnemyType("units/payday2/characters/ene_spook_1/ene_spook_1")
BoR_Enemy:Get_EnemyType("units/payday2/characters/ene_tazer_1/ene_tazer_1")
BoR_Enemy:Get_EnemyType("units/payday2/characters/ene_sniper_1/ene_sniper_1")
BoR_Enemy:Get_EnemyType("units/payday2/characters/ene_shield_1/ene_shield_1")
BoR_Enemy:Get_EnemyType("units/payday2/characters/ene_shield_2/ene_shield_2")
BoR_Enemy:Get_EnemyType("units/payday2/characters/ene_bulldozer_1/ene_bulldozer_1")
BoR_Enemy:Get_EnemyType("units/payday2/characters/ene_bulldozer_2/ene_bulldozer_2")
BoR_Enemy:Get_EnemyType("units/payday2/characters/ene_bulldozer_3/ene_bulldozer_3")
BoR_Enemy:Get_EnemyType("units/pd2_dlc_drm/characters/ene_bulldozer_medic/ene_bulldozer_medic")
BoR_Enemy:Get_EnemyType("units/pd2_dlc_drm/characters/ene_bulldozer_minigun/ene_bulldozer_minigun")
BoR_Enemy:Get_EnemyType("units/pd2_dlc_drm/characters/ene_bulldozer_minigun_classic/ene_bulldozer_minigun_classic")