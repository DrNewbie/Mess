local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local mvec3_add = mvector3.add
local mvec3_ang = mvector3.angle
local mvec3_dis = mvector3.distance
local mvec3_mul = mvector3.multiply
local mvec3_neq = mvector3.not_equal
local mvec3_set = mvector3.set
local mvec3_set_z = mvector3.set_z
local tmp_vec1 = Vector3()
local tmp_vec2 = Vector3()

local table_insert = table.insert

_G.CustomWaypoints = _G.CustomWaypoints or {}
CustomWaypoints._path = ModPath
CustomWaypoints._data_path = SavePath .. 'CustomWaypoints.txt'
CustomWaypoints.prefix = 'CustomWaypoint_'
CustomWaypoints.last_cycle_t = 0
CustomWaypoints.network = {
	place_waypoint = 'CustomWaypointPlace',
	attach_waypoint = 'CustomWaypointAttach',
	remove_waypoint = 'CustomWaypointRemove'
}
CustomWaypoints.settings = {
	show_distance = true,
	always_show_my_waypoint = true,
	always_show_others_waypoints = false,
	include_lootbags_in_points_of_interest = true,
	include_hostages_in_points_of_interest = true,
}
CustomWaypoints.interactive_units_white_list = { -- false if contour not required
	[Idstring('units/equipment/apartment_saw/apartment_saw'):t()] = true,
	[Idstring('units/equipment/c4_charge/c4_plantable'):t()] = true,
	[Idstring('units/equipment/garden_tap_interactive/hose_end_interactive_suburbia'):t()] = true,
	[Idstring('units/payday2/architecture/res_ext_apartment/res_pipes_valve'):t()] = true,
	[Idstring('units/payday2/equipment/gen_equipment_camera_hackingtool/gen_equipment_camera_hackingtool'):t()] = true,
	[Idstring('units/payday2/equipment/gen_interactable_drill_small/gen_interactable_drill_small'):t()] = true,
	[Idstring('units/payday2/equipment/gen_interactable_lance_huge/gen_interactable_lance_huge'):t()] = true,
	[Idstring('units/payday2/equipment/gen_interactable_laptop_camera/gen_interactable_laptop_camera'):t()] = false,
	[Idstring('units/payday2/equipment/gen_interactable_zipline/gen_interactable_zipline_mount_ground'):t()] = true,
	[Idstring('units/payday2/equipment/item_door_drill_small/item_door_drill_small'):t()] = true,
	[Idstring('units/payday2/pickups/gen_pku_bodybag/gen_pku_bodybag'):t()] = true,
	[Idstring('units/payday2/pickups/gen_pku_lootbag/gen_pku_lootbag'):t()] = true,
	[Idstring('units/payday2/pickups/gen_pku_toolbag/gen_pku_toolbag'):t()] = true,
	[Idstring('units/payday2/pickups/gen_pku_toolbag_large/gen_pku_toolbag_large'):t()] = true,
	[Idstring('units/pd2_dlc_arena/props/are_prop_security_button/are_prop_security_button'):t()] = true,
	[Idstring('units/pd2_dlc_berry/props/bry_prop_breaching_charge/bry_prop_breaching_charge'):t()] = true,
	[Idstring('units/pd2_dlc_born/props/bor_prop_garage_bike_assembly/parts/bor_prop_garage_assembly_part_engine'):t()] = true,
	[Idstring('units/pd2_dlc_casino/props/cas_prop_drill/cas_prop_watertank_01'):t()] = true,
	[Idstring('units/pd2_dlc_casino/props/cas_prop_drill/cas_prop_watertank_02'):t()] = true,
	[Idstring('units/pd2_dlc_casino/props/cas_prop_drill/cas_prop_watertank_static'):t()] = true,
	[Idstring('units/pd2_dlc_dah/dah_interactable_laptop/dah_interactable_laptop'):t()] = true,
	[Idstring('units/pd2_dlc_glace/equipment/glc_interactable_ejectionseat/glc_interactable_ejectionseat'):t()] = true,
	[Idstring('units/pd2_dlc_glace/equipment/gen_interactable_saw_no_jam/gen_interactable_saw_no_jam'):t()] = true,
	[Idstring('units/pd2_dlc_glace/equipment/gen_interactable_saw_no_jam/gen_interactable_saw_no_jam_rotated'):t()] = true,
	[Idstring('units/pd2_dlc_jerry/pickups/jry_pku_ladder/jry_pku_pickable_ladder'):t()] = true,
	[Idstring('units/pd2_dlc_jerry/pickups/jry_pku_money_pile/jry_pku_money_pile'):t()] = true,
	[Idstring('units/pd2_dlc_jolly/equipment/gen_interactable_saw/gen_interactable_saw'):t()] = true,
	[Idstring('units/pd2_dlc_peta/characters/wld_goat_1/wld_goat_1'):t()] = true,
	[Idstring('units/pd2_dlc_peta/equipment/pta_interactable_saw/pta_interactable_saw'):t()] = true,
	[Idstring('units/pd2_dlc_peta/props/pta_interactable_electric_box/pta_interactable_electric_box'):t()] = true, -- fail
	[Idstring('units/pd2_dlc_peta/props/pta_prop_debris_wood/pta_prop_debris_wood_01'):t()] = true,
	[Idstring('units/pd2_dlc_peta/props/pta_prop_debris_wood/pta_prop_debris_wood_02'):t()] = true,
	[Idstring('units/pd2_dlc_rvd/equipment/rvd_interactable_drill_small_jam_once/rvd_interactable_drill_small_jam_once'):t()] = true,
	[Idstring('units/pd2_dlc_rvd/equipment/rvd_interactable_saw_no_jam/rvd_interactable_saw_no_jam'):t()] = true,
	[Idstring('units/pd2_dlc_rvd/props/rvd_prop_diamond_bag/rvd_prop_diamond_bag'):t()] = true,
	[Idstring('units/pd2_dlc_spa/vehicles/str_vehicle_car_police_new_york/str_vehicle_car_police_new_york'):t()] = true,
}

function CustomWaypoints:Save()
	local file = io.open(self._data_path, 'w+')
	if file then
		file:write(json.encode(self.settings))
		file:close()
	end
end

function CustomWaypoints:Load()
	local file = io.open(self._data_path, 'r')
	if file then
		for k, v in pairs(json.decode(file:read('*all')) or {}) do
			self.settings[k] = v
		end
		file:close()
	end
end

Hooks:Add('LocalizationManagerPostInit', 'LocalizationManagerPostInit_CustomWaypoints', function(loc)
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
		for _, filename in pairs(file.GetFiles(CustomWaypoints._path .. 'loc/')) do
			local str = filename:match('^(.*).txt$')
			if str and Idstring(str) and Idstring(str):key() == SystemInfo:language():key() then
				language_filename = filename
				break
			end
		end
	end

	if language_filename then
		loc:load_localization_file(CustomWaypoints._path .. 'loc/' .. language_filename)
	end
	loc:load_localization_file(CustomWaypoints._path .. 'loc/english.txt', false)
end)

Hooks:Add('MenuManagerInitialize', 'MenuManagerInitialize_CustomWaypoints', function(menu_manager)
	MenuCallbackHandler.CustomWaypointsMenuCheckboxClbk = function(this, item)
		CustomWaypoints.settings[item:name()] = item:value() == 'on'
	end

	MenuCallbackHandler.CustomWaypointsSave = function(this, item)
		CustomWaypoints:Save()
	end

	MenuCallbackHandler.KeybindRemoveWaypoint = function(this, item)
		if Utils:IsInGameState() then
			CustomWaypoints:RemoveMyWaypoint()
		end
	end

	MenuCallbackHandler.KeybindPlaceWaypoint = function(this, item)
		if Utils:IsInGameState() then
			CustomWaypoints:PlaceMyWaypoint()
		end
	end

	MenuCallbackHandler.KeybindPreviousWaypoint = function(this, item)
		if Utils:IsInGameState() then
			CustomWaypoints:PreviousWaypoint()
		end
	end

	MenuCallbackHandler.KeybindNextWaypoint = function(this, item)
		if Utils:IsInGameState() then
			CustomWaypoints:NextWaypoint()
		end
	end

	CustomWaypoints:Load()
	MenuHelper:LoadFromJsonFile(CustomWaypoints._path .. 'menu/options.txt', CustomWaypoints, CustomWaypoints.settings)
end)

function CustomWaypoints:GetAssociatedObjectiveWaypoint(search_pos, radius, account_custom_waypoints)
	local waypoints = managers.hud and managers.hud._hud and managers.hud._hud.waypoints
	if not waypoints then
		return
	end

	radius = radius or 10

	if not search_pos then
		local my_wp = waypoints[self.prefix .. 'localplayer']
		if not my_wp then
			return
		end
		search_pos = my_wp.position
	end

	for id, waypoint in pairs(waypoints) do
		if not account_custom_waypoints and type(id) == 'string' and id:find(self.prefix) then
		elseif waypoint.position then
			if mvec3_dis(search_pos, waypoint.position) < radius then
				return id, waypoint
			end
		end
	end

	return false
end

-- Add
function CustomWaypoints:PlaceWaypoint(waypoint_name, object, peer_id)
	if managers.hud then
		local data = {
			icon = 'infamy_icon',
			distance = self.settings.show_distance,
			no_sync = false,
			present_timer = 0,
			state = 'present',
			radius = 50,
			color = tweak_data.preplanning_peer_colors[peer_id or 1],
			blend_mode = 'add'
		}
		data[object.type_name == 'Unit' and 'unit' or 'position'] = object
		managers.hud:add_waypoint(self.prefix .. waypoint_name, data)
	end
end

function Utils:GetCrosshairRay(from, to, slot_mask)
	local viewport = managers.viewport
	if not viewport:get_current_camera() then
		return false
	end

	slot_mask = slot_mask or 'bullet_impact_targets'

	from = from or viewport:get_current_camera_position()

	if not to then
		to = tmp_vec1
		mvec3_set(to, viewport:get_current_camera_rotation():y())
		mvec3_mul(to, 20000)
		mvec3_add(to, from)
	end

	local col_ray = World:raycast('ray', from, to, 'slot_mask', managers.slot:get_mask(slot_mask))
	return col_ray
end

function CustomWaypoints:GetMyAimPos()
	local viewport = managers.viewport
	local camera_rot = viewport:get_current_camera_rotation()
	if not camera_rot then
		return false
	end

	local from = tmp_vec2
	mvec3_set(from, camera_rot:y())
	mvec3_mul(from, 20)
	mvec3_add(from, viewport:get_current_camera_position())

	local ray = Utils:GetCrosshairRay(from, nil, 'player_ground_check')
	if not ray then
		return false
	end

	return ray.hit_position, ray
end

function CustomWaypoints:PlaceMyWaypoint(object)
	if not object then
		object = self:GetMyAimPos()
	end

	if not object then
		return
	elseif object.type_name == 'Unit' and alive(object) then
		LuaNetworking:SendToPeers(self.network.attach_waypoint, tostring(object:id()))
	elseif object.type_name == 'Vector3' then
		LuaNetworking:SendToPeers(self.network.place_waypoint, Vector3.ToString(object))
	else
		return
	end

	self:PlaceWaypoint('localplayer', object, LuaNetworking:LocalPeerID())
end

function CustomWaypoints:NetworkAttach(peer_id, unit_id)
	if peer_id then
		unit_id = tonumber(unit_id)
		for _, unit in ipairs(managers.interaction._interactive_units) do
			if alive(unit) and unit:id() == unit_id then
				self:PlaceWaypoint(peer_id, unit, peer_id)
			end
		end
	end
end

function CustomWaypoints:NetworkPlace(peer_id, position)
	if peer_id then
		local pos = string.ToVector3(position)
		if pos ~= nil then
			self:PlaceWaypoint(peer_id, pos, peer_id)
		end
	end
end

-- Remove
function CustomWaypoints:RemoveWaypoint(waypoint_name)
	if managers.hud then
		managers.hud:remove_waypoint(self.prefix .. waypoint_name)
	end
end

function CustomWaypoints:RemoveMyWaypoint()
	LuaNetworking:SendToPeers(self.network.remove_waypoint, '')
	self:RemoveWaypoint('localplayer')
end

function CustomWaypoints:NetworkRemove(peer_id)
	self:RemoveWaypoint(peer_id)
end

-- Cycle
local ids_contour_color = Idstring('contour_color')
local ids_contour_opacity = Idstring('contour_opacity')
local ids_material = Idstring('material')
local no_color = Vector3(0, 0, 0)
function CustomWaypoints.UnitHasContour(unit)
	for _, material in ipairs(unit:get_objects_by_type(ids_material)) do
		if alive(material) then
			local opacity = material:get_variable(ids_contour_opacity)
			if opacity and opacity > 0 then
				local color = material:get_variable(ids_contour_color)
				if color and mvec3_neq(color, no_color) then
					return true
				end
			end
		end
	end
	return false
end

function CustomWaypoints:GetSortedWaypoints(include_points_of_interest)
	local waypoints = managers.hud and managers.hud._hud and managers.hud._hud.waypoints
	if not waypoints then
		return
	end

	local result = {}
	local camera_pos = managers.viewport:get_current_camera_position()
	local _, ray = self:GetMyAimPos()
	if not ray then
		return
	end

	local my_aim = ray.ray
	for id, waypoint in pairs(waypoints) do
		if type(id) == 'string' and id:find(self.prefix) then
		elseif waypoint.position then
			local angle = mvec3_ang(my_aim, waypoint.position - camera_pos)
			if angle < 40 then
				table_insert(result, {
					id = id,
					position = waypoint.position,
					angle = mvec3_ang(my_aim, waypoint.position - camera_pos)
				})
			end
		end
	end

	if include_points_of_interest then
		if self.settings.include_hostages_in_points_of_interest then
			for _, unit in ipairs(World:find_units_quick('all', 12, 21, 22)) do
				if alive(unit) then
					local anim = unit:anim_data()
					if anim and (anim.tied or anim.hands_tied) then
						local pos = unit:position()
						local angle = mvec3_ang(my_aim, pos - camera_pos)
						if angle < 40 then
							table_insert(result, {
								unit = unit,
								position = pos,
								angle = angle
							})
						end
					end
				end
			end
		end

		local include_lootbags = self.settings.include_lootbags_in_points_of_interest
		for _, unit in ipairs(managers.interaction._interactive_units) do
			if alive(unit) and unit:visible() and (include_lootbags and unit:slot() == 14 or unit:slot() == 1) then
				local interaction = unit:interaction()
				if interaction and interaction:active() and not interaction:disabled() then
					local require_contour = self.interactive_units_white_list[unit:name():t()]
					if require_contour == false or require_contour == true and self.UnitHasContour(unit) then
						local pos = interaction:interact_position()
						local angle = mvec3_ang(my_aim, pos - camera_pos)
						if angle < 40 then
							table_insert(result, {
								unit = unit,
								position = pos,
								angle = angle
							})
						end
					end
				end
			end
		end
	end

	table.sort(result, function(a, b)
		return a.angle < b.angle
	end)

	return result
end

function CustomWaypoints:CycleWaypoint(dir)
	local sorted_waypoints = self:GetSortedWaypoints(true)
	if not sorted_waypoints then
		return
	end

	local nr = #sorted_waypoints
	if nr == 0 then
		return
	end

	local current_wp_rank
	local my_wp = managers.hud._hud.waypoints[self.prefix .. 'localplayer']
	if my_wp then
		for i = 1, nr do
			wp = sorted_waypoints[i]
			if mvec3_dis(my_wp.position, wp.position) < 10 then
				current_wp_rank = i
				break
			end
		end
	end

	local rank
	local t = TimerManager:game():time()
	if not current_wp_rank then
		rank = dir > 0 and 1 or nr
	elseif t - self.last_cycle_t < 2 then
		rank = current_wp_rank + dir
		rank = ((rank - 1) % nr) + 1
	else
		rank = dir > 0 and 1 or nr
		if rank == current_wp_rank then
			rank = current_wp_rank + dir
			rank = ((rank - 1) % nr) + 1
		end
	end

	local chosen_wp = sorted_waypoints[rank]
	local carrier = alive(chosen_wp.unit) and chosen_wp.unit:slot() == 14 and chosen_wp.unit.carry_data and chosen_wp.unit:carry_data():is_linked_to_unit()
	self:PlaceMyWaypoint(carrier and carrier:in_slot(managers.slot:get_mask('enemies')) and chosen_wp.unit or chosen_wp.position)

	self.last_cycle_t = t
end

function CustomWaypoints:PreviousWaypoint()
	self:CycleWaypoint(-1)
end

function CustomWaypoints:NextWaypoint()
	self:CycleWaypoint(1)
end
