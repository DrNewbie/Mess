local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

_G.Monkeepers = _G.Monkeepers or {}
Monkeepers.settings = {
	nail = false,
}
Monkeepers.path = ModPath
Monkeepers.data_path = SavePath .. 'monkeepers.txt'
Monkeepers.options_menu_id = 'mkp_options_menu'
Monkeepers.last_interaction_was_carrydrop = {}
Monkeepers.last_carry_pickup_pos = {}
Monkeepers.lootbag_vectors = {}
Monkeepers.lootareas = {}
Monkeepers.ziplines = {}

Monkeepers.radius_pickup_zone = 600
Monkeepers.min_distance_to_create_vector = 700
Monkeepers.min_distance_to_create_vector_from_shelf = 1400
Monkeepers.min_vector_lifetime = 60

Monkeepers.draw_debug = false
Monkeepers.brush_start = Draw:brush(Color(100, 0, 0, 255) / 255, 2)
Monkeepers.brush_link = Draw:brush(Color(100, 192, 255, 0) / 255, 2)
Monkeepers.brush_link_to_dropzone = Draw:brush(Color(236, 192, 255, 0) / 255, 2)
Monkeepers.brush_end = Draw:brush(Color(100, 0, 255, 0) / 255, 2)

local mvec3_add = mvector3.add
local mvec3_dis = mvector3.distance
local mvec3_cpy = mvector3.copy
local mvec3_set = mvector3.set
local mvec3_set_z = mvector3.set_z
local mvec3_sub = mvector3.subtract
local mvec3_z = mvector3.z
local tmp_vec1 = Vector3()
local tmp_vec2 = Vector3()

local math_abs = math.abs
local table_remove = table.remove

function Monkeepers:IsAcceptableCarry(carry_id)
	local acceptable_carry = {
		cage_bag = true,
		lance_bag_large = true,
		safe_wpn = true,
		safe_ovk = true,
		winch_part = true,
		winch_part_2 = true,
		winch_part_3 = true,
	}
	if acceptable_carry[carry_id] then
		return true
	end

	local td = tweak_data.carry[carry_id]
	if td.bag_value or td.AI_carry then
		return true
	end

	return false
end

function Monkeepers:LoadSettings()
	local file = io.open(self.data_path, 'r')
	if file then
		for k, v in pairs(json.decode(file:read('*all')) or {}) do
			self.settings[k] = v
		end
		file:close()
	end

	local level_id = Global.game_settings and Global.game_settings.level_id or ''
	level_id = level_id:gsub('_night$', ''):gsub('_day$', '')
	self.disabled = self.settings[level_id] == false
end

function Monkeepers:SaveSettings()
	local file = io.open(self.data_path, 'w+')
	if file then
		file:write(json.encode(self.settings))
		file:close()
	end
end

local lootbag_vec = Vector3(0, 0, 100)
local tmpvec1 = Vector3()
local tmpvec2 = Vector3()
local lootbag_mask = World:make_slot_mask(14)
function Monkeepers:GetBagsAround(pos, radius, include_carried)
	local pos1 = tmpvec1
	local pos2 = tmpvec2
	mvec3_set(pos1, pos)
	mvec3_set(pos2, pos1)
	mvec3_add(pos1, lootbag_vec)
	mvec3_add(pos1, lootbag_vec) -- oui, 2
	mvec3_sub(pos2, lootbag_vec)
	local result = World:find_units('intersect', 'cylinder', pos1, pos2, radius or self.radius_pickup_zone, lootbag_mask)
	for i = #result, 1, -1 do
		local unit = result[i]
		if not unit.carry_data or not unit:carry_data() or not include_carried and unit:carry_data():is_linked_to_unit() then
			table_remove(result, i)
		end
	end
	return result
end

function Monkeepers:IsDropzoneOK(dropzone, position)
	if not dropzone or type(dropzone) ~= 'table' then
	elseif type(dropzone.sync_store_loot_in_vehicle) == 'function' then
		if alive(dropzone._unit) and dropzone:is_interaction_enabled(VehicleDrivingExt.INTERACT_LOOT) then
			if not dropzone._tweak_data or #dropzone._loot < dropzone._tweak_data.max_loot_bags then
				return not position or mvec3_dis(position, dropzone._unit:position()) < 20
			end
		end
	elseif type(dropzone.enabled) == 'function' then
		return dropzone:enabled()
	end

	return false
end

function Monkeepers:MoreImportantBagExist(cur_lv)
	local t = TimerManager:game():time()
	local lv_prio = {}
	for _, lv in pairs(self.lootbag_vectors) do
		if lv.created_t < cur_lv.created_t then
			if not lv.failed_t or t - lv.failed_t > 15 then
				if not lv.dropzone or self:IsDropzoneOK(lv.dropzone) then
					lv_prio[lv] = true
				end
			end
		end
	end

	local bags = World:find_units_quick('all', 14)
	self:DeleteObsoleteRoutes(bags)

	for i = #bags, 1, -1 do
		local unit = bags[i]
		if alive(unit) and unit.carry_data then
			local carry_data = unit:carry_data()
			if carry_data and not carry_data:is_linked_to_unit() then
				local carry_SO_data = carry_data._carry_SO_data
				if carry_SO_data and carry_SO_data.mkp_lv and lv_prio[carry_SO_data.mkp_lv] then
					return true
				end
			end
		end
	end

	return false
end

function Monkeepers:DeleteObsoleteRoutes(bags)
	local lv_in_use = {}

	local bags = bags or World:find_units_quick('all', 14)
	for i = #bags, 1, -1 do
		local unit = bags[i]
		if alive(unit) and unit.carry_data then
			local carry_data = unit:carry_data()
			if carry_data then
				local carry_SO_data = carry_data._carry_SO_data
				if carry_SO_data and carry_SO_data.mkp_lv then
					lv_in_use[carry_SO_data.mkp_lv] = true
				end
			end
		end
	end

	local to_delete = {}
	local t = TimerManager:game():time()
	for pickup_pos, lv in pairs(self.lootbag_vectors) do
		if lv.dropzone or lv_in_use[lv] then
		elseif lv.created_t + self.min_vector_lifetime < t then
			table.insert(to_delete, pickup_pos)
		end
	end
	for _, pickup_pos in ipairs(to_delete) do
		self.lootbag_vectors[pickup_pos] = nil
	end
end

function Monkeepers:BagZiplineNearPos(pos)
	for _, zipline_startpos in pairs(self.ziplines) do
		if mvec3_dis(pos, zipline_startpos) < 600 then
			return true
		end
	end
	return false
end

function Monkeepers:DrawLootbagVectors()
	for pickup_pos, lv in pairs(self.lootbag_vectors) do
		self:DrawLootbagVector(pickup_pos, lv)
	end
end

local brush_vec = Vector3(0, 0, 5)
function Monkeepers:DrawLootbagVector(pickup_pos, lv)
	self.brush_start:cylinder(pickup_pos, pickup_pos + brush_vec, self.radius_pickup_zone)
	self.brush_end:cylinder(lv.throw_pos, lv.throw_pos + brush_vec, 50)
	local brush = lv.dropzone and self.brush_link_to_dropzone or self.brush_link
	brush:cone(lv.throw_pos, pickup_pos, 20)
end

function Monkeepers:AddLootbagVector(pickup_pos, land_pos, dest_pos, dest_rot, dest_dir, throw_distance_multiplier_upgrade_level, dropzone)
	self:DeleteOppositeLootbagVector(pickup_pos, land_pos)
	local previously_created_t = self:DeleteLootbagVector(pickup_pos, true)

	local pickup_pos = mvec3_cpy(pickup_pos)
	local new_vector = {
		created_t = previously_created_t or TimerManager:game():time(),
		throw_pos = mvec3_cpy(dest_pos),
		land_pos = mvec3_cpy(land_pos),
		rot = Rotation(dest_rot:yaw(), 0, 0),
		dir = mvec3_cpy(dest_dir),
		throw_distance_multiplier_upgrade_level = throw_distance_multiplier_upgrade_level,
		dropzone = dropzone
	}
	self.lootbag_vectors[pickup_pos] = new_vector
	if self.draw_debug then
		self:DrawLootbagVector(pickup_pos, new_vector)
	end

	local bags_nearby_previous_pos = self:GetBagsAround(pickup_pos)
	local filters = Monkeepers:GetDropzoneFilters(dropzone)
	for _, bag_unit in ipairs(bags_nearby_previous_pos) do
		if alive(bag_unit) then
			local carry_data = bag_unit:carry_data()
			if carry_data and (not filters or filters[carry_data._carry_id]) then
				carry_data:mkp_chk_register_carry_SO()
			end
		end
	end

	return new_vector
end

function Monkeepers:CancelEverything()
	local bags = World:find_units_quick('all', 14)
	for i = #bags, 1, -1 do
		local unit = bags[i]
		if alive(unit) and unit.carry_data then
			local carry_data = unit:carry_data()
			if carry_data and carry_data._carry_SO_data then
				self:DeleteBagSO(unit, true)
			end
		end
	end

	self.lootbag_vectors = {}
end

function Monkeepers:DeleteLootbagVectorByData(lv_to_remove, remove_so)
	for pickup_pos, lv in pairs(self.lootbag_vectors) do
		if lv == lv_to_remove then
			self.lootbag_vectors[pickup_pos] = nil
			if remove_so then
				self:DeleteSOAround(pickup_pos)
			end
			break
		end
	end
end

function Monkeepers:DeleteLootbagVector(pos, remove_so, forced_interrupt)
	local created_t

	for pickup_pos, lv in pairs(self.lootbag_vectors) do
		if mvec3_dis(pickup_pos, pos) < self.radius_pickup_zone then
			created_t = math.min(created_t or lv.created_t, lv.created_t)
			self.lootbag_vectors[pickup_pos] = nil
			if remove_so then
				self:DeleteSOAround(pickup_pos, forced_interrupt)
			end
		end
	end

	return created_t
end

function Monkeepers:DeleteBagSO(bag_unit, forced_interrupt)
	local carry_data = bag_unit:carry_data()
	local carrier = carry_data._carry_SO_data and carry_data._carry_SO_data.carrier
	if not alive(carrier) then
		carry_data:mkp_unregister_carry_SO()
	elseif forced_interrupt then
		carry_data:mkp_unregister_carry_SO()
		carrier:brain():set_objective(nil)
	end
end

function Monkeepers:DeleteSOAround(pickup_pos, forced_interrupt)
	for _, bag_unit in ipairs(self:GetBagsAround(pickup_pos, self.radius_pickup_zone, forced_interrupt)) do
		self:DeleteBagSO(bag_unit, forced_interrupt)
	end
end

function Monkeepers:DeleteOppositeLootbagVector(new_pickup_pos, new_land_pos)
	for pickup_pos, lv in pairs(self.lootbag_vectors) do
		if mvec3_dis(pickup_pos, new_land_pos) < self.radius_pickup_zone and mvec3_dis(lv.land_pos, new_pickup_pos) < self.radius_pickup_zone then
			self.lootbag_vectors[pickup_pos] = nil
			local bags_nearby_previous_pos = self:GetBagsAround(pickup_pos)
			for _, bag_unit in ipairs(bags_nearby_previous_pos) do
				self:DeleteBagSO(bag_unit, true)
			end
		end
	end
end

function Monkeepers:DoLootbagVector(peer, land_pos, dest_pos, dest_rot, dest_dir, throw_distance_multiplier_upgrade_level, dropzone)
	local peer_id = peer:id()
	local pickup_pos = self.last_carry_pickup_pos[peer_id] or dropzone and dest_pos
	if pickup_pos then
		local do_create
		if dropzone then
			do_create = true
		elseif math.abs(land_pos.z - pickup_pos.z) > 250 then
			do_create = true
		elseif self.last_interaction_was_carrydrop[peer_id] then
			do_create = mvec3_dis(land_pos, pickup_pos) > self.min_distance_to_create_vector
		else
			do_create = mvec3_dis(land_pos, pickup_pos) > self.min_distance_to_create_vector_from_shelf
		end

		if do_create then
			return self:AddLootbagVector(pickup_pos, land_pos, dest_pos, dest_rot, dest_dir, throw_distance_multiplier_upgrade_level, dropzone)
		else
			if self.last_interaction_was_carrydrop[peer_id] then
				self:DeleteLootbagVector(pickup_pos, true, true)
			end
		end
	end
end

function Monkeepers:FindLootbagVector(pos)
	local result
	local min_dis = 100000000
	local pos_z = mvec3_z(pos)
	mvec3_set(tmp_vec1, pos)
	for pickup_pos, lv in pairs(self.lootbag_vectors) do
		local pick_z = mvec3_z(pickup_pos)
		mvec3_set(tmp_vec2, pickup_pos)
		if math_abs(pos_z - pick_z) <= 100 then
			local dis = mvec3_dis(tmp_vec1, tmp_vec2)
			if dis < min_dis then
				min_dis = dis
				if min_dis < self.radius_pickup_zone then
					result = lv
				end
			end
		end
	end
	return result
end

Monkeepers:LoadSettings()

Hooks:Add('LocalizationManagerPostInit', 'LocalizationManagerPostInit_Monkeepers', function(loc)
	local language_filename

	local modname_to_language = {
		['PAYDAY 2 THAI LANGUAGE Mod'] = 'thai.txt',
	}
	for _, mod in pairs(BLT and BLT.Mods:Mods() or {}) do
		language_filename = mod:IsEnabled() and modname_to_language[mod:GetName()]
		if language_filename then
			break
		end
	end

	if not language_filename then
		for _, filename in pairs(file.GetFiles(Monkeepers.path .. 'loc/')) do
			local str = filename:match('^(.*).txt$')
			if str and Idstring(str) and Idstring(str):key() == SystemInfo:language():key() then
				language_filename = filename
				break
			end
		end
	end

	if language_filename then
		loc:load_localization_file(Monkeepers.path .. 'loc/' .. language_filename)
	end
	loc:load_localization_file(Monkeepers.path .. 'loc/english.txt', false)
end)

Hooks:Add('MenuManagerInitialize', 'MenuManagerInitialize_Monkeepers', function(menu_manager)
	MenuCallbackHandler.MonkeepersDeleteAllRoutes = function(this, item)
		if Network:is_server() then
			Monkeepers:CancelEverything()
		end
	end

	MenuCallbackHandler.MonkeepersHub = function(this, item)
		Monkeepers.settings[item:name()] = item:value() == 'on'
	end

	MenuCallbackHandler.MonkeepersChangedFocus = function(node, focus)
		if not focus then
			Monkeepers:SaveSettings()
		end
	end

	MenuHelper:LoadFromJsonFile(Monkeepers.path .. 'menu/options.txt', Monkeepers, Monkeepers.settings)

	Hooks:Add('MenuManagerBuildCustomMenus', 'MenuManagerBuildCustomMenus_Monkeepers', function(menu_manager, nodes)
		nodes.mkp_options_menu:parameters().modifier = {MonkeepersCreator.modify_node}
	end)
end)

MonkeepersCreator = MonkeepersCreator or class()
function MonkeepersCreator.modify_node(node)
	local old_items = node:items()

	node:clean_items()

	for i = 1, 2 do
		node:add_item(table.remove(old_items, 1))
	end

	local ordered = {}
	for level_id, level_data in pairs(tweak_data.levels) do
		if not level_data.name_id then
		elseif level_id == 'chill' then
		elseif not managers.localization:exists(level_data.name_id) then
		elseif level_id:match('^short[0-9]_') then
		elseif level_id:match('_day$') then
		elseif level_id:match('_night$') then
		else
			table.insert(ordered, {
				level_id = level_id,
				level_data = level_data,
				txt = managers.localization:text(level_data.name_id)
			})
		end
	end
	table.sort(ordered, function(a, b) return a.txt < b.txt end)

	local data = {
		type = 'CoreMenuItemToggle.ItemToggle',
		{
			_meta = 'option',
			icon = 'guis/textures/menu_tickbox',
			value = 'on',
			x = 24,
			y = 0,
			w = 24,
			h = 24,
			s_icon = 'guis/textures/menu_tickbox',
			s_x = 24,
			s_y = 24,
			s_w = 24,
			s_h = 24
		},
		{
			_meta = 'option',
			icon = 'guis/textures/menu_tickbox',
			value = 'off',
			x = 0,
			y = 0,
			w = 24,
			h = 24,
			s_icon = 'guis/textures/menu_tickbox',
			s_x = 0,
			s_y = 24,
			s_w = 24,
			s_h = 24
		}
	}

	for _, level in pairs(ordered) do
		local params = {
			name = level.level_id,
			text_id = level.level_data.name_id,
			help_id = level.level_id,
			callback = 'MonkeepersHub',
			to_upper = false,
			localize = true,
			localize_help = false
		}
		local new_item = node:create_item(data, params)
		new_item:set_value(Monkeepers.settings[level.level_id] == false and 'off' or 'on')
		node:add_item(new_item)
	end

	managers.menu:add_back_button(node)

	return node
end

function Monkeepers:MakeBotsDropBagImmediately(peer)
	for ukey, record in pairs(managers.groupai:state()._ai_criminals) do
		local bot_unit = record.unit
		if alive(bot_unit) and bot_unit:movement():carrying_bag() and bot_unit:movement().mkp_autopicked then
			local objective = bot_unit:brain():objective()
			if objective and objective.type == 'follow' and objective.follow_unit == peer:unit() then
				local carry = bot_unit:movement():carry_data()
				bot_unit:movement():throw_bag()
				if carry then
					carry._carry_SO_data = nil
				end
			end
		end
	end
end

function Monkeepers:AssignDropObjectiveToBots(peer, lv)
	local filters = Monkeepers:GetDropzoneFilters(lv.dropzone)
	for ukey, record in pairs(managers.groupai:state()._ai_criminals) do
		local bot_unit = record.unit
		if alive(bot_unit) then
			local unit_brain = bot_unit:brain()
			local objective = unit_brain:objective()
			if objective then
				if objective.type == 'follow' and objective.follow_unit == peer:unit() then
					local carry_data = bot_unit:movement():carry_data()
					if carry_data and (not filters or filters[carry_data._carry_id]) then
						local drop_objective = carry_data:mkp_make_drop_objective(lv)
						drop_objective.followup_objective = objective
						unit_brain:set_objective(drop_objective)
					end
				elseif alive(objective.mkp_bag) then
					local followup_objective = objective.followup_objective
					if followup_objective and followup_objective.type == 'follow' and followup_objective.follow_unit == peer:unit() then
						local carry_data = objective.mkp_bag:carry_data()
						if not filters or filters[carry_data._carry_id] then
							local drop_objective = carry_data:mkp_make_drop_objective(lv)
							objective.followup_objective = drop_objective
						end
					end
				end
			end
		end
	end
end

function Monkeepers:GetDropzoneFilters(dropzone)
	if type(dropzone) ~= 'table' then
		return
	end

	local results

	if dropzone._rules_elements then
		-- good map maker
		for _, element in ipairs(dropzone._rules_elements) do
			local rules = element and element._values and element._values.rules
			local ids = rules and rules.loot and rules.loot.carry_ids
			if ids then
				results = results or {}
				for cid in pairs(ids) do
					results[cid] = cid
				end
			end
		end
		return results
	end

	if dropzone._values and dropzone._values.on_executed then
		for _, data in ipairs(dropzone._values.on_executed) do
			local element = managers.mission:get_element_by_id(data.id)
			if element and element.class == 'ElementCarry' then
				local filter = element._values.type_filter
				if not filter or filter == 'none' then
					return
				end
				-- most probably bad map maker
				results = results or {}
				results[filter] = filter
			end
		end
		return results
	end
end

if not Monkeepers.disabled and Network:is_server() then
	local mkp_original_playermanager_serverdropcarry = PlayerManager.server_drop_carry
	function PlayerManager:server_drop_carry(carry_id, carry_multiplier, dye_initiated, has_dye_pack, dye_value_multiplier, position, rotation, dir, throw_distance_multiplier_upgrade_level, zipline_unit, peer)
		local unit = mkp_original_playermanager_serverdropcarry(self, carry_id, carry_multiplier, dye_initiated, has_dye_pack, dye_value_multiplier, position, rotation, dir, throw_distance_multiplier_upgrade_level, zipline_unit, peer)

		if peer and not zipline_unit and alive(unit) and Monkeepers:IsAcceptableCarry(carry_id) then
			local carry_data = unit:carry_data()
			if carry_data then
				carry_data.mkp_spawn_position = mvec3_cpy(position)
				local peer_unit = peer:unit()
				local pos = mvec3_cpy(peer_unit:position())
				local rot = peer:id() == 1 and managers.viewport:get_current_camera_rotation() or peer_unit:rotation()
				rot = Rotation(rot:yaw(), 0, 0)
				local dir = mvec3_cpy(dir)

				carry_data.mkp_callback = function(dropzone, dropzone_position)
					carry_data.mkp_callback = nil
					local lv = Monkeepers:DoLootbagVector(peer, unit:position(), pos, rot, dir, throw_distance_multiplier_upgrade_level, dropzone)
					if lv then
						carry_data.mkp_lv = lv
						if dropzone then
							lv.position = dropzone_position and mvec3_cpy(dropzone_position)
							Monkeepers:AssignDropObjectiveToBots(peer, lv)
						elseif not carry_data:is_linked_to_unit() then
							Monkeepers:AssignDropObjectiveToBots(peer, lv)
						else
							Monkeepers:DeleteLootbagVectorByData(lv, true)
						end
					else
						if alive(unit) and not carry_data:is_linked_to_unit() then
							Monkeepers:MakeBotsDropBagImmediately(peer)
						end
					end
				end
			end
		end

		return unit
	end
end
