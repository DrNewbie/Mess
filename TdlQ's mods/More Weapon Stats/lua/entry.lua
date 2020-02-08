_G.MoreWeaponStats = _G.MoreWeaponStats or {}
MoreWeaponStats._path = ModPath
MoreWeaponStats._data_path = SavePath .. 'more_weapon_stats.txt'
MoreWeaponStats.stance_color = Color(0.114, 0.736, 0.517)
MoreWeaponStats.settings = {
	show_dlc_info = true,
	last_used_difficulty = 'overkill_290',
	fill_breakpoints = true,
	use_preview_to_switch_breakpoints = true,
	clicks_per_second = 5,
	enable_trigger_happy_for_first_bullet = true
}

function MoreWeaponStats:Load()
	local file = io.open(self._data_path, 'r')
	if file then
		for k, v in pairs(json.decode(file:read('*all')) or {}) do
			self.settings[k] = v
		end
		file:close()
	end
end

function MoreWeaponStats:Save()
	local file = io.open(self._data_path, 'w+')
	if file then
		file:write(json.encode(self.settings))
		file:close()
	end
end

local function function_empty()
end

local function function_zero()
	return 0
end

local function make_function_returns_params_x(x)
	return function(...)
		local params = {...}
		return params[x]
	end
end

_G.Overrider = _G.Overrider or class()

function Overrider:init()
	self.things = {}
end

function Overrider:remember(obj, id)
	table.insert(self.things, { obj, id, obj[id] })
end

function Overrider:replace(obj, id, v)
	table.insert(self.things, { obj, id, obj[id] })
	obj[id] = v
end

function Overrider:replace_once(obj, id, v)
	for _, thing in ipairs(self.things) do
		if thing[1] == obj and thing[2] == id then
			return
		end
	end
	self:replace(obj, id, v)
end

function Overrider:revert_all()
	local thing = table.remove(self.things)
	while thing do
		thing[1][thing[2]] = thing[3]
		thing = table.remove(self.things)
	end
end

_G.Faker = _G.Faker or {
	using_game_classes = false,
	classes = {},
	overrider = Overrider:new(),
}

function Faker:redo_class(name, parent_name)
	if not _G[name] then
		log('class not redone: ' .. name)
		return
	end
	local parent = self.classes[parent_name]
	local result = class(parent)
	for k, v in pairs(_G[name]) do
		if type(v) == 'function' then
			result[k] = v
		end
	end
	self.classes[name] = result
end

function Faker:swap_redone_classes()
	for k, v in pairs(self.classes) do
		_G[k], self.classes[k] = self.classes[k], _G[k]
	end
end

function Faker:use_game_classes()
	self.overrider:replace_once(managers, 'enemy', self.fill_with_empty_methods(EnemyManager))
	self.overrider:replace_once(managers, 'statistics', self.fill_with_empty_methods(StatisticsManager))
	self.overrider:replace_once(managers.player, 'remove_property', function_empty)
	self.overrider:replace_once(managers.player, 'send_message_now', function_empty)
	self.overrider:replace_once(managers, 'achievment', self.fill_with_empty_methods(AchievmentManager))
	self.overrider:replace_once(managers, 'challenge', self.fill_with_empty_methods(ChallengeManager))
	self.overrider:replace_once(managers, 'hud', self.fill_with_empty_methods(HUDManager))
	self.overrider:replace_once(managers, 'job', self.fill_with_empty_methods(JobManager))
	self.overrider:replace_once(managers, 'mission', self.fill_with_empty_methods(MissionManager))

	if self.using_game_classes then
		return
	end

	self.using_game_classes = true
	self:swap_redone_classes()

	return true
end

function Faker:use_normal_classes()
	self.overrider:revert_all()

	if not self.using_game_classes then
		return
	end

	self.using_game_classes = false
	self:swap_redone_classes()

	return true
end

function Faker.spy(tbl, name, recursive, verbose, processed)
	if verbose then log('spy ' .. tostring(name) .. '	-> ' .. tostring(tbl)) end
	if recursive then
		processed = processed or {}
		processed[tbl] = true
		for k, v in pairs(tbl) do
			if k ~= 'faker_model' and type(v) == 'table' and not processed[v] and not getmetatable(v) then
				tbl[k] = Faker.spy(v, k, recursive, verbose, processed)
			end
		end
	end

	if getmetatable(tbl) then
		return tbl
	end

	return setmetatable({}, {
		__index = function (t, k)
			if verbose then log(('> accessed %s.%s'):format(tostring(name), tostring(k))) end
			if not tbl[k] and tbl.faker_model and type(tbl.faker_model[k]) == 'function' then
				return function(...)
					if verbose then log(('> called "%s.%s" with %i parameters'):format(tostring(name), tostring(k), table.size({...}))) end
				end
			end
			return tbl[k]
		end
	})
end

function Faker.fill_with_empty_methods(source, result)
	result = result or {}

	if type(source.super) == 'table' then
		result = Faker.fill_with_empty_methods(source.super, result)
	end

	local holder = source
	if type(source) == 'userdata' then
		holder = getmetatable(source)
	end

	for k, v in pairs(holder) do
		if type(v) == 'function' and not result[k] then
			result[k] = function_empty
		end
	end

	return result
end

function Faker.make_playerstate(player_unit, weapon_base, st_moving, st_ducking, st_deploy, st_steelsight)
	local result = {
		faker_model = PlayerStandard,
		_unit = player_unit,
		_change_weapon_data = {},
		_equipped_unit = weapon_base._unit,
		_ext_camera = Faker.fill_with_empty_methods(PlayerCamera),
		_ext_inventory = player_unit and player_unit:inventory(),
		_ext_network = Faker.fill_with_empty_methods(NetworkBaseExtension),
		_ext_movement = player_unit and player_unit:movement(),
		_moving = st_moving,
		_state_data = {
			using_bipod = st_deploy,
			ducking = st_ducking,
			in_steelsight = st_steelsight,
		},
	}
	result = Faker.fill_with_empty_methods(PlayerStandard, result)

	result._get_swap_speed_multiplier = PlayerStandard._get_swap_speed_multiplier
	result._start_action_equip_weapon = PlayerStandard._start_action_equip_weapon
	result._start_action_unequip_weapon = PlayerStandard._start_action_unequip_weapon
	result._start_action_reload_enter = PlayerStandard._start_action_reload_enter
	result._start_action_reload = PlayerStandard._start_action_reload
	result._update_reload_timers = PlayerStandard._update_reload_timers
	result.get_movement_state = PlayerStandard.get_movement_state
	result.in_steelsight = PlayerStandard.in_steelsight

	return result
end

function Faker.make_unit()
	local result = Faker.fill_with_empty_methods(Unit)
	result.faker_model = Unit

	local id = math.random(1000000000)
	result.id = function()
		return id
	end

	result.key = function()
		return 'key ' .. id
	end

	return result
end

function Faker.make_player_unit(weapon_base, st_moving, st_ducking, st_deploy, st_steelsight)
	local result = Faker.make_unit()

	local original_player_unit = managers.player.player_unit
	managers.player.player_unit = function()
		return result
	end

	result.m_head_pos = function()
		return Vector3()
	end

	result._inventory = PlayerInventory:new(result)
	result._inventory._link_weapon = function_empty
	result.inventory = function(self)
		return self._inventory
	end

	result._movement = {}
	result.movement = function(self)
		return self._movement
	end

	result._network = Faker.fill_with_empty_methods(NetworkBaseExtension)
	result.network = function(self)
		return self._network
	end

	result._unit_data = {}
	result.unit_data = function(self)
		return self._unit_data
	end

	result._movement._current_state = Faker.make_playerstate(result, weapon_base, st_moving, st_ducking, st_deploy, st_steelsight)
	result._inventory:add_unit(weapon_base._unit, true, true)

	managers.player.player_unit = original_player_unit

	return result
end

function Faker.make_sounddevice()
	local result = {
		create_source = function()
			return {
				link = function_empty,
				post_event = function_empty,
				set_switch = function_empty,
			}
		end,
	}
	result = Faker.fill_with_empty_methods(SoundDevice, result)
	return result
end

function Faker.get_weapon_base_class_name(name_id, npc)
	local result

	local td = tweak_data.weapon[name_id]
	local categories = td.categories and table.list_to_set(td.categories)
	if not categories then
		result = npc and 'NewNPCRaycastWeaponBase' or 'NewRaycastWeaponBase'
	elseif categories.shotgun then
		if categories.akimbo then
			result = npc and 'NPCAkimboShotgunBase' or 'AkimboShotgunBase'
		elseif td.timers.reload_not_empty then
			result = not npc and 'SaigaShotgun'
		else
			result = npc and 'NPCShotgunBase' or 'ShotgunBase'
		end
	elseif categories.flamethrower then
		result = npc and 'NewNPCFlamethrowerBase' or 'NewFlamethrowerBase'
	elseif categories.grenade_launcher then
		if td.timers.shotgun_reload_enter then
			result = not npc and 'GrenadeLauncherContinousReloadBase'
		else
			result = npc and 'NPCGrenadeLauncherBase' or 'GrenadeLauncherBase'
		end
	elseif categories.bow then
		result = npc and 'NPCBowWeaponBase' or 'BowWeaponBase'
	elseif categories.crossbow then
		result = npc and 'NPCCrossBowWeaponBase' or 'CrossbowWeaponBase'
	elseif categories.akimbo then
		result = npc and 'NPCAkimboWeaponBase' or 'AkimboWeaponBase'
	elseif categories.saw then
		result = npc and 'NPCSawWeaponBase' or 'SawWeaponBase'
	else
		result = npc and 'NewNPCRaycastWeaponBase' or 'NewRaycastWeaponBase'
	end

	return result
end

function Faker:craft_weapon_base_class(class_name, factory_id, blueprint, name_id)
	local c_norm_list = self.using_game_classes and self.classes or _G
	local c_game_list = self.using_game_classes and _G or self.classes

	local cls = c_game_list[class_name] or c_norm_list[class_name]
	if not cls then
		cls = c_game_list[class_name] or c_norm_list[class_name]
	end

	local fake_class_name = 'Fake' .. class_name
	if _G[fake_class_name] then
		return _G[fake_class_name]
	end

	local FakeWeaponBase = class(cls)
	_G[fake_class_name] = FakeWeaponBase

	function FakeWeaponBase:init(unit, factory_id, blueprint, name_id)
		self._blueprint = blueprint
		self._factory_id = factory_id
		self.name_id = name_id

		local original_sounddevice = SoundDevice
		SoundDevice = Faker.make_sounddevice()
		FakeWeaponBase.super.init(self, unit)
		SoundDevice = original_sounddevice
	end

	function FakeWeaponBase:setup_default()
		self._ammo_data = self._ammo_data or managers.weapon_factory:get_ammo_data_from_weapon(self._factory_id, self._blueprint) or {}
		FakeWeaponBase.super.setup_default(self)
	end

	return FakeWeaponBase
end

function Faker:make_weapon_base(factory_id, blueprint, name_id, npc, forced_class)
	if self.menuland and not self.using_game_classes then
		log('someone forgot to call use_game_classes()...')
	end

	if npc then
		local npc_name_id = name_id .. '_crew'
		if not tweak_data.weapon[npc_name_id] then
			npc_name_id = name_id .. '_npc'
		end
		if tweak_data.weapon[npc_name_id] then
			name_id = npc_name_id
		end
	end

	local class_name = forced_class or self.get_weapon_base_class_name(name_id, npc)
	local fake_unit = self.make_unit()
	local FakeClass = self:craft_weapon_base_class(class_name, factory_id, blueprint, name_id)

	local wbase = FakeClass:new(fake_unit, factory_id, blueprint, name_id)

	fake_unit.base = function()
		return wbase
	end

	wbase.name_id = name_id
	wbase._assembly_complete = true
	wbase._parts = {}
	wbase._gadgets = {}
	wbase.add_destroy_listener = function_empty
	wbase.on_reload = function_empty

	wbase:_update_stats_values()
	if not npc then
		wbase._next_fire_allowed = 0
		wbase:update_next_shooting_time()
		wbase:update_damage()
	end

	return wbase
end
