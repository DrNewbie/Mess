function itr_set_load_data(data, seg2vg)
	local rid = #data.room_borders_x_neg + 1
	data.room_borders_x_pos[rid] = 119
	data.room_borders_x_neg[rid] = 117
	data.room_borders_y_pos[rid] = 111
	data.room_borders_y_neg[rid] = 110
	data.room_heights_xp_yp[rid] = 74
	data.room_heights_xp_yn[rid] = 22.5
	data.room_heights_xn_yp[rid] = 74
	data.room_heights_xn_yn[rid] = 22.5
	data.room_vis_groups[rid] = seg2vg[55]
	data.vis_groups[seg2vg[55]].rooms[rid] = true

	local did = #data.door_high_pos + 1
	data.door_low_pos[did] = Vector3(117, 110, 22.5)
	data.door_high_pos[did] = Vector3(119, 110, 22.5)
	data.door_low_rooms[did] = 456
	data.door_high_rooms[did] = rid

	rid = rid + 1
	data.room_borders_x_pos[rid] = 119
	data.room_borders_x_neg[rid] = 117
	data.room_borders_y_pos[rid] = 122
	data.room_borders_y_neg[rid] = 111
	data.room_heights_xp_yp[rid] = 181
	data.room_heights_xp_yn[rid] = 74
	data.room_heights_xn_yp[rid] = 181
	data.room_heights_xn_yn[rid] = 74
	data.room_vis_groups[rid] = seg2vg[55]
	data.vis_groups[seg2vg[55]].rooms[rid] = true

	did = did + 1
	data.door_low_pos[did] = Vector3(117, 111, 74)
	data.door_high_pos[did] = Vector3(119, 111, 74)
	data.door_low_rooms[did] = rid - 1
	data.door_high_rooms[did] = rid

	rid = rid + 1
	data.room_borders_x_pos[rid] = 119
	data.room_borders_x_neg[rid] = 117
	data.room_borders_y_pos[rid] = 134
	data.room_borders_y_neg[rid] = 122
	data.room_heights_xp_yp[rid] = 280
	data.room_heights_xp_yn[rid] = 181
	data.room_heights_xn_yp[rid] = 280
	data.room_heights_xn_yn[rid] = 181
	data.room_vis_groups[rid] = seg2vg[90]
	data.vis_groups[seg2vg[90]].rooms[rid] = true

	did = did + 1
	data.door_low_pos[did] = Vector3(117, 122, 181)
	data.door_high_pos[did] = Vector3(119, 122, 181)
	data.door_low_rooms[did] = rid - 1
	data.door_high_rooms[did] = rid

	data.nav_segments[55].neighbours[90] = { did }
	data.nav_segments[90].neighbours[55] = { did }

	rid = rid + 1
	data.room_borders_x_pos[rid] = 119
	data.room_borders_x_neg[rid] = 117
	data.room_borders_y_pos[rid] = 135
	data.room_borders_y_neg[rid] = 134
	data.room_heights_xp_yp[rid] = 222.5
	data.room_heights_xp_yn[rid] = 280
	data.room_heights_xn_yp[rid] = 222.5
	data.room_heights_xn_yn[rid] = 280
	data.room_vis_groups[rid] = seg2vg[90]
	data.vis_groups[seg2vg[90]].rooms[rid] = true

	did = did + 1
	data.door_low_pos[did] = Vector3(117, 134, 280)
	data.door_high_pos[did] = Vector3(119, 134, 280)
	data.door_low_rooms[did] = rid - 1
	data.door_high_rooms[did] = rid

	did = did + 1
	data.door_low_pos[did] = Vector3(117, 135, 222.5)
	data.door_high_pos[did] = Vector3(119, 135, 222.5)
	data.door_low_rooms[did] = 685
	data.door_high_rooms[did] = rid

	rid = 685
	data.room_borders_y_neg[rid] = 135
end
