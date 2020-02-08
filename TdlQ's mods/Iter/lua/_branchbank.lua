function itr_set_load_data(data, seg2vg)
	-- prevent chars to walk into wall
	local rid = 551
	data.room_borders_y_pos[rid] = 41
	local did = 999
	mvector3.set_y(data.door_high_pos[did], 41)

	-- Parking, grid side
	rid = #data.room_borders_x_neg + 1
	data.room_borders_x_pos[rid] = -129
	data.room_borders_x_neg[rid] = -130
	data.room_borders_y_pos[rid] = 76
	data.room_borders_y_neg[rid] = 53
	data.room_heights_xp_yp[rid] = 22.5
	data.room_heights_xp_yn[rid] = 22.5
	data.room_heights_xn_yp[rid] = 22.5
	data.room_heights_xn_yn[rid] = 22.5
	data.room_vis_groups[rid] = seg2vg[17]
	data.vis_groups[seg2vg[17]].rooms[rid] = true

	did = #data.door_low_pos + 1
	data.door_low_pos[did] = Vector3(-130, 76, 22.5)
	data.door_high_pos[did] = Vector3(-129, 76, 22.5)
	data.door_low_rooms[did] = 504
	data.door_high_rooms[did] = rid

	did = did + 1
	data.door_low_pos[did] = Vector3(-130, 53, 22.5)
	data.door_high_pos[did] = Vector3(-129, 53, 22.5)
	data.door_low_rooms[did] = 553
	data.door_high_rooms[did] = rid
	table.insert(data.nav_segments[17].neighbours[18], did)
	table.insert(data.nav_segments[18].neighbours[17], did)

	data.room_borders_x_pos[508] = -130
	did = did + 1
	data.door_low_pos[did] = Vector3(-130, 66, 22.5)
	data.door_high_pos[did] = Vector3(-130, 67, 22.5)
	data.door_low_rooms[did] = 508
	data.door_high_rooms[did] = rid

	-- Parking, other side
	rid = rid + 1
	data.room_borders_x_pos[rid] = -110
	data.room_borders_x_neg[rid] = -124
	data.room_borders_y_pos[rid] = 114
	data.room_borders_y_neg[rid] = 113
	data.room_heights_xp_yp[rid] = 22.5
	data.room_heights_xp_yn[rid] = 22.5
	data.room_heights_xn_yp[rid] = 22.5
	data.room_heights_xn_yn[rid] = 22.5
	data.room_vis_groups[rid] = seg2vg[15]
	data.vis_groups[seg2vg[15]].rooms[rid] = true

	did = did + 1
	data.door_low_pos[did] = Vector3(-110, 113, 22.5)
	data.door_high_pos[did] = Vector3(-110, 114, 22.5)
	data.door_low_rooms[did] = 375
	data.door_high_rooms[did] = rid

	did = did + 1
	data.door_low_pos[did] = Vector3(-124, 113, 22.5)
	data.door_high_pos[did] = Vector3(-124, 114, 22.5)
	data.door_low_rooms[did] = 414
	data.door_high_rooms[did] = rid
end
