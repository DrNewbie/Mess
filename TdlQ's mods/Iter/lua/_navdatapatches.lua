local mvec3_cpy = mvector3.copy
local mvec3_set_x = mvector3.set_x
local mvec3_set_y = mvector3.set_y

local function _load_custom_data(level_id)
	dofile(Iter._path .. '/lua/_' .. level_id .. '.lua')
end

local function _segment_to_vis_groups(data)
	local result = {}
	for i, vg in ipairs(data.vis_groups) do
		result[vg.seg] = i
	end
	return result
end

local function _make_transfer_function(data)
	local seg2vg = _segment_to_vis_groups(data)
	local transfer_room = function(id, from, to)
		data.vis_groups[seg2vg[from]].rooms[id] = nil
		data.vis_groups[seg2vg[to]].rooms[id] = true
		data.room_vis_groups[id] = seg2vg[to]
	end
	return transfer_room, seg2vg
end

local level_id = Iter:get_level_id()

local itr_original_navigationmanager_setloaddata = NavigationManager.set_load_data

if not Iter.settings['map_change_' .. level_id] then
	-- qued

elseif level_id == 'alex_2'
	or level_id == 'big'
	or level_id == 'branchbank'
	or level_id == 'roberts'
then

	_load_custom_data(level_id)

	function NavigationManager:set_load_data(data)
		local seg2vg = _segment_to_vis_groups(data)
		itr_set_load_data(data, seg2vg)

		itr_original_navigationmanager_setloaddata(self, data)
	end

elseif level_id == 'mia_1' then

	_load_custom_data(level_id)

	function NavigationManager:set_load_data(data)
		local seg2vg = _segment_to_vis_groups(data)
		itr_set_load_data(data, seg2vg)

		local transfer_room = _make_transfer_function(data)

		transfer_room(1901, 20, 113) -- room 102 / underground
		transfer_room(1902, 20, 113)
		transfer_room(1903, 20, 113)
		transfer_room(1904, 20, 113)
		transfer_room(1905, 20, 113)
		transfer_room(1906, 20, 113)
		transfer_room(1907, 20, 113)
		transfer_room(1910, 20, 113)
		data.nav_segments[20].neighbours[113] = {3207}
		data.nav_segments[113].neighbours[20] = {3207}

		transfer_room(1945, 119, 22) -- room 103 / underground
		transfer_room(1946, 119, 22)
		data.nav_segments[22].neighbours[119] = {3276,3277,3281}
		data.nav_segments[119].neighbours[22] = {3276,3277,3281}

		itr_original_navigationmanager_setloaddata(self, data)
	end

elseif level_id == 'jolly' then

	function NavigationManager:set_load_data(data)
		data.room_borders_x_pos[2718] = data.room_borders_x_pos[2718] + 2
		data.room_borders_y_neg[2718] = data.room_borders_y_neg[2718] - 1
		data.room_borders_y_pos[3743] = data.room_borders_y_pos[3743] + 1

		local pos = mvec3_cpy(data.door_high_pos[5105])
		mvec3_set_x(data.door_high_pos[5105], pos.x + 1)

		mvec3_set_x(pos, data.room_borders_x_neg[3743])
		mvec3_set_y(pos, data.room_borders_y_pos[3743])
		local pos1 = mvec3_cpy(pos)
		mvec3_set_y(pos1, pos1.y - 1)
		table.insert(data.door_low_pos, pos)
		table.insert(data.door_high_pos, pos1)
		table.insert(data.door_low_rooms, 2718)
		table.insert(data.door_high_rooms, 3743)

		data.nav_segments[141].neighbours[87] = { #data.door_low_pos }
		data.nav_segments[87].neighbours = { [141] = { #data.door_low_pos } }

		itr_original_navigationmanager_setloaddata(self, data)
	end

elseif level_id == 'moon' then

	function NavigationManager:set_load_data(data)
		data.room_borders_x_neg[2777] = data.room_borders_x_neg[2777] - 1
		data.room_borders_y_neg[2777] = data.room_borders_y_neg[2777] - 1

		local pos = mvec3_cpy(data.door_high_pos[4981])
		mvec3_set_x(pos, pos.x - 2)
		mvec3_set_y(pos, pos.y - 2)
		local pos1 = mvec3_cpy(pos)
		mvec3_set_x(pos1, pos1.x + 1)
		table.insert(data.door_low_pos, pos)
		table.insert(data.door_high_pos, pos1)
		table.insert(data.door_low_rooms, 2777)
		table.insert(data.door_high_rooms, 2758)

		data.nav_segments[22].neighbours[23] = { #data.door_low_pos }
		data.nav_segments[23].neighbours = { [22] = { #data.door_low_pos } }

		itr_original_navigationmanager_setloaddata(self, data)
	end

elseif level_id == 'arm_for' then

	function NavigationManager:set_load_data(data)
		local transfer_room = _make_transfer_function(data)

		-- 2701 and 2703 are clones, that's a new level of fucked up
		-- 2705 and 2713 are clones, won't bother to delete that and their doors

		transfer_room(2689, 57, 56)

		transfer_room(2701, 58, 59)

		transfer_room(2704, 59, 60)
		transfer_room(2705, 59, 60)
		transfer_room(2706, 59, 60)
		transfer_room(2707, 59, 60)
		transfer_room(2708, 59, 60)
		transfer_room(2709, 59, 60)
		transfer_room(2710, 59, 60)
		transfer_room(2711, 59, 60)
		transfer_room(2712, 59, 60)

		data.nav_segments[56].neighbours[57] = {5188}
		data.nav_segments[57].neighbours[56] = {5188}

		data.nav_segments[59].neighbours[60] = {5210}
		data.nav_segments[60].neighbours[59] = {5210}

		data.nav_segments[59].neighbours[58] = {5195}
		data.nav_segments[58].neighbours[59] = {5195}

		itr_original_navigationmanager_setloaddata(self, data)
	end

elseif level_id == 'crojob2' then

	function NavigationManager:set_load_data(data)
		local transfer_room = _make_transfer_function(data)

		transfer_room(414, 28, 74)
		transfer_room(417, 28, 74)
		transfer_room(418, 28, 74)
		transfer_room(424, 28, 74)

		for _, door_id in ipairs(data.nav_segments[28].neighbours[52]) do
			table.insert(data.nav_segments[74].neighbours[52], door_id)
			table.insert(data.nav_segments[52].neighbours[74], door_id)
		end
		data.nav_segments[28].neighbours[52] = nil
		data.nav_segments[52].neighbours[28] = nil

		for _, door_id in ipairs({758, 764, 772, 773}) do
			table.insert(data.nav_segments[28].neighbours[74], door_id)
			table.insert(data.nav_segments[74].neighbours[28], door_id)
		end

		for _, door_id in ipairs({1776, 1777}) do
			table.delete(data.nav_segments[28].neighbours[74], door_id)
			table.delete(data.nav_segments[74].neighbours[28], door_id)
		end

		itr_original_navigationmanager_setloaddata(self, data)
	end

elseif level_id == 'mex' then

	function NavigationManager:set_load_data(data)
		local transfer_room = _make_transfer_function(data)

		transfer_room(3908, 235, 192)
		transfer_room(3916, 235, 192)
		transfer_room(3907, 235, 192)
		transfer_room(3896, 235, 192)
		transfer_room(3906, 235, 192)
		transfer_room(3899, 235, 192)
		transfer_room(3889, 235, 192)
		transfer_room(3898, 235, 192)
		data.nav_segments[235].neighbours[192] = { 6866, 6867, 6868, 6833, 6834, 6835 }
		data.nav_segments[192].neighbours[235] = { 6866, 6867, 6868, 6833, 6834, 6835 }

		transfer_room(2627, 214, 192)
		data.nav_segments[214].neighbours[192] = { 4662, 4663, 4664 }
		data.nav_segments[192].neighbours[214] = { 4662, 4663, 4664 }

		itr_original_navigationmanager_setloaddata(self, data)
	end

elseif level_id == 'kosugi' then

	function NavigationManager:set_load_data(data)
		local rooms_to_transfer = {
			1744,
			1747,
			1751,
			1752,
			1753,
			1755,
			1756,
			1758,
			1759,
			1766,
			1767,
			1772
		}
		for _, room_id in ipairs(rooms_to_transfer) do
			data.vis_groups[2].rooms[room_id] = nil
			data.vis_groups[3].rooms[room_id] = true
			data.room_vis_groups[room_id] = 3
		end

		for _, door_id in ipairs(data.nav_segments[123].neighbours[2]) do
			table.insert(data.nav_segments[123].neighbours[3], door_id)
			table.insert(data.nav_segments[3].neighbours[123], door_id)
		end
		data.nav_segments[2].neighbours[123] = nil
		data.nav_segments[123].neighbours[2] = nil

		data.nav_segments[2].neighbours[3] = { 3028 }
		data.nav_segments[3].neighbours[2] = { 3028 }

		itr_original_navigationmanager_setloaddata(self, data)
	end

elseif level_id == 'born' then

	function NavigationManager:set_load_data(data)
		data.room_borders_y_pos[2798] = 111

		table.insert(data.door_low_pos, Vector3(-149, 111, 22.4998))
		table.insert(data.door_high_pos, Vector3(-146, 111, 22.4998))
		table.insert(data.door_low_rooms, 2798)
		table.insert(data.door_high_rooms, 3405)

		table.insert(data.door_low_pos, Vector3(-146, 111, 22.4998))
		table.insert(data.door_high_pos, Vector3(-140, 111, 22.4998))
		table.insert(data.door_low_rooms, 2798)
		table.insert(data.door_high_rooms, 3381)

		table.insert(data.door_low_pos, Vector3(-140, 111, 22.4998))
		table.insert(data.door_high_pos, Vector3(-138, 111, 22.4998))
		table.insert(data.door_low_rooms, 2798)
		table.insert(data.door_high_rooms, 3379)

		data.nav_segments[50].neighbours[51] = { 6275, 6276, 6277 }
		data.nav_segments[51].neighbours[50] = { 6275, 6276, 6277 }

		itr_original_navigationmanager_setloaddata(self, data)
	end

elseif level_id == 'peta' then

	function NavigationManager:set_load_data(data)
		local pos = mvec3_cpy(data.door_high_pos[11860])
		mvector3.set_y(pos, pos.y + 4)
		local pos1 = mvec3_cpy(pos)
		mvector3.set_y(pos1, pos1.y + 9)
		table.insert(data.door_low_pos, pos)
		table.insert(data.door_high_pos, pos1)
		table.insert(data.door_low_rooms, 97)
		table.insert(data.door_high_rooms, 5959)

		data.nav_segments[47].neighbours[91] = { #data.door_low_pos }
		data.nav_segments[91].neighbours = { [47] = { #data.door_low_pos } }

		itr_original_navigationmanager_setloaddata(self, data)
	end

elseif level_id == 'gallery' or level_id == 'framing_frame_1' then

	function NavigationManager:set_load_data(data)
		local vg = {
			rooms = {
				[858] = true,
				[859] = true,
				[870] = true,
				[871] = true,
				[872] = true,
				[873] = true,
				[881] = true,
				[883] = true,
				[884] = true
			},
			pos = Vector3(2457, 6, 0),
			seg = 100,
			vis_groups = {}
		}
		for k, v in pairs(data.vis_groups) do
			vg.vis_groups[k] = true
		end
		table.insert(data.vis_groups, vg)

		local seg2vg = _segment_to_vis_groups(data)
		for room_id in pairs(vg.rooms) do
			data.vis_groups[seg2vg[13]].rooms[room_id] = nil
			data.room_vis_groups[room_id] = seg2vg[100]
		end
		data.nav_segments[100] = {
			location_id = 'location_unknown',
			pos = Vector3(2457, 6, 0),
			vis_groups = { seg2vg[100] },
			neighbours = {
				[1] = data.nav_segments[1].neighbours[13],
				[13] = {1561, 1589, 1590, 1616}
			}
		}

		data.nav_segments[1].neighbours[100] = data.nav_segments[1].neighbours[13]
		data.nav_segments[13].neighbours[100] = data.nav_segments[100].neighbours[13]

		data.nav_segments[1].neighbours[13] = nil
		data.nav_segments[13].neighbours[1] = nil

		itr_original_navigationmanager_setloaddata(self, data)
	end

elseif level_id == 'watchdogs_1' then

	function NavigationManager:set_load_data(data)
		local seg2vg = _segment_to_vis_groups(data)

		local transfer_room = _make_transfer_function(data)

		transfer_room(896, 134, 52)
		transfer_room(897, 134, 52)
		transfer_room(898, 134, 52)
		transfer_room(899, 134, 52)

		local d134t52 = data.nav_segments[134].neighbours[52]
		local d52t134 = data.nav_segments[52].neighbours[134]

		local old_doors = {
			1852,
			1855,
			1943,
			1944,
			1949,
			1953,
			1959,
			1960,
		}
		for _, door_id in ipairs(old_doors) do
			table.delete(d134t52, door_id)
			table.delete(d52t134, door_id)
		end

		local new_doors = {
			1564,
			1565,
			1566,
			1573,
		}
		for _, door_id in ipairs(new_doors) do
			table.insert(d134t52, door_id)
			table.insert(d52t134, door_id)
		end

		itr_original_navigationmanager_setloaddata(self, data)
	end

elseif level_id == 'pbr' then

	function NavigationManager:set_load_data(data)
		data.room_borders_y_pos[1222] = -286
		local did = #data.door_high_pos + 1
		data.door_low_pos[did] = Vector3(38, -287, -58)
		data.door_high_pos[did] = Vector3(38, -286, -82)
		data.door_low_rooms[did] = 1147
		data.door_high_rooms[did] = 1222
		data.nav_segments[39].neighbours[40] = {did}
		data.nav_segments[40].neighbours[39] = data.nav_segments[39].neighbours[40]

		data.room_borders_x_pos[5714] = -30
		data.room_borders_y_pos[5714] = -96

		did = did + 1
		data.door_low_pos[did] = Vector3(-30, -97, -160.145)
		data.door_high_pos[did] = Vector3(-30, -96, -160.145)
		data.door_low_rooms[did] = 990
		data.door_high_rooms[did] = 5714
		data.nav_segments[30].neighbours[52] = {did}
		data.nav_segments[52].neighbours[30] = data.nav_segments[30].neighbours[52]

		itr_original_navigationmanager_setloaddata(self, data)
	end

elseif level_id == 'jewelry_store' then

	function NavigationManager:set_load_data(data)
		local seg2vg = _segment_to_vis_groups(data)

		local rid = #data.room_borders_x_neg + 1
		data.room_borders_x_pos[rid] = -8
		data.room_borders_x_neg[rid] = -12
		data.room_borders_y_pos[rid] = 87
		data.room_borders_y_neg[rid] = 86
		data.room_heights_xp_yp[rid] = 27.5
		data.room_heights_xp_yn[rid] = 27.5
		data.room_heights_xn_yp[rid] = 27.5
		data.room_heights_xn_yn[rid] = 27.5
		data.room_vis_groups[rid] = seg2vg[5]
		data.vis_groups[seg2vg[5]].rooms[rid] = true

		local did = #data.door_high_pos + 1
		data.door_low_pos[did] = Vector3(-12, 86, 27.5)
		data.door_high_pos[did] = Vector3(-11, 86, 27.5)
		data.door_low_rooms[did] = 882
		data.door_high_rooms[did] = rid
		table.insert(data.nav_segments[5].neighbours[96], did)
		table.insert(data.nav_segments[96].neighbours[5], did)

		did = did + 1
		data.door_low_pos[did] = Vector3(-8, 86, 27.5)
		data.door_high_pos[did] = Vector3(-8, 87, 27.5)
		data.door_low_rooms[did] = 826
		data.door_high_rooms[did] = rid

		itr_original_navigationmanager_setloaddata(self, data)
	end

elseif level_id == 'dinner' then

	local itr_original_navigationmanager_addobstacle = NavigationManager.add_obstacle
	function NavigationManager:add_obstacle(obstacle_unit, ...)
		if obstacle_unit:unit_data().unit_id == 102343 then
			local pos = obstacle_unit:position()
			mvector3.set_z(pos, pos.z - 10)
			obstacle_unit:set_position(pos)
		end

		itr_original_navigationmanager_addobstacle(self, obstacle_unit, ...)
	end

elseif level_id == 'flat' then

	local downed_obstacle_units = {}
	local itr_original_navigationmanager_addobstacle = NavigationManager.add_obstacle
	function NavigationManager:add_obstacle(obstacle_unit, ...)
		if not downed_obstacle_units[obstacle_unit] and tostring(obstacle_unit:name()) == 'Idstring(@IDbc8566d71eae8505@)' then
			local pos = obstacle_unit:position()
			local z = pos.z
			downed_obstacle_units[obstacle_unit] = true
			mvector3.set_z(pos, z - 5)
			obstacle_unit:set_position(pos)
		end

		itr_original_navigationmanager_addobstacle(self, obstacle_unit, ...)
	end

end
