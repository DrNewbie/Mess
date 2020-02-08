function itr_set_load_data(data, seg2vg)
	-- Jimbo's in
	local rid = #data.room_borders_x_neg + 1
	data.room_borders_x_pos[rid] = -30
	data.room_borders_x_neg[rid] = -34
	data.room_borders_y_pos[rid] = 101
	data.room_borders_y_neg[rid] = 84
	data.room_heights_xp_yp[rid] = -18.14
	data.room_heights_xp_yn[rid] = -18.14
	data.room_heights_xn_yp[rid] = -18.14
	data.room_heights_xn_yn[rid] = -18.14
	data.room_vis_groups[rid] = seg2vg[218]
	data.vis_groups[seg2vg[218]].rooms[rid] = true

	-- Jimbo's out
	rid = rid + 1
	data.room_borders_x_pos[rid] = 7
	data.room_borders_x_neg[rid] = -10
	data.room_borders_y_pos[rid] = 103
	data.room_borders_y_neg[rid] = 95
	data.room_heights_xp_yp[rid] = -68.21
	data.room_heights_xp_yn[rid] = -68.21
	data.room_heights_xn_yp[rid] = -68.21
	data.room_heights_xn_yn[rid] = -68.21
	data.room_vis_groups[rid] = seg2vg[3]
	data.vis_groups[seg2vg[3]].rooms[rid] = true
end
