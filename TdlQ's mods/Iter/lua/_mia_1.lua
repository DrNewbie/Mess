function itr_set_load_data(data, seg2vg)
	local rid = #data.room_borders_x_neg
	local function make_room(borders_x_pos, borders_x_neg, borders_y_pos, borders_y_neg, heights_xp_yp, heights_xp_yn, heights_xn_yp, heights_xn_yn, segment_id)
		rid = rid + 1
		data.room_borders_x_pos[rid] = borders_x_pos
		data.room_borders_x_neg[rid] = borders_x_neg
		data.room_borders_y_pos[rid] = borders_y_pos
		data.room_borders_y_neg[rid] = borders_y_neg
		data.room_heights_xp_yp[rid] = heights_xp_yp
		data.room_heights_xp_yn[rid] = heights_xp_yn
		data.room_heights_xn_yp[rid] = heights_xn_yp
		data.room_heights_xn_yn[rid] = heights_xn_yn
		data.room_vis_groups[rid] = seg2vg[segment_id]
		data.vis_groups[seg2vg[segment_id]].rooms[rid] = true
	end

	-- room 101
	make_room(222, 213, -79, -85, 47.5, 47.5, 47.5, 47.5, 3)
	make_room(222, 219, -55, -62, 47.5, 47.5, 47.5, 47.5, 3)

	-- room 102
	make_room(222, 213, -135, -141, 47.5, 47.5, 47.5, 47.5, 20)
	make_room(222, 219, -111, -118, 47.5, 47.5, 47.5, 47.5, 20)

	-- room 103
	make_room(195, 189, -148, -153, 47.5, 47.5, 47.5, 47.5, 22)
	make_room(222, 207, -148, -156, 47.5, 47.5, 47.5, 47.5, 22)
	make_room(222, 220, -173, -181, 47.5, 47.5, 47.5, 47.5, 22)

	-- room 104
	make_room(145, 138, -167, -176, 47.5, 47.5, 47.5, 47.5, 9)
	make_room(168, 160, -174, -176, 47.5, 47.5, 47.5, 47.5, 9)

	-- room 105
	make_room(131, 127, -143, -176, 47.5, 47.5, 47.5, 47.5, 26)
	make_room(104, 98, -143, -149, 47.5, 47.5, 47.5, 47.5, 26)
	make_room(105, 98, -174, -176, 47.5, 47.5, 47.5, 47.5, 26)

	-- room 106
	make_room(46, 40, -167, -176, 47.5, 47.5, 47.5, 47.5, 12)
	make_room(70, 63, -174, -176, 47.5, 47.5, 47.5, 47.5, 12)

	-- room 107
	make_room(33, 24, -167, -176, 47.5, 47.5, 47.5, 47.5, 48)
	make_room(7, 0, -174, -176, 47.5, 47.5, 47.5, 47.5, 48)
	make_room(6, 0, -143, -149, 47.5, 47.5, 47.5, 47.5, 48)

	-- room 108
	make_room(-15, -24, -92, -98, 47.5, 47.5, 47.5, 47.5, 6)

	-- room 202
	make_room(204, 189, -111, -118, 447.5, 447.5, 447.5, 447.5, 5)
	make_room(197, 189, -139, -144, 447.5, 447.5, 447.5, 447.5, 5)

	-- room 203
	make_room(194, 189, -148, -154, 447.5, 447.5, 447.5, 447.5, 7)
	make_room(194, 189, -174, -181, 447.5, 447.5, 447.5, 447.5, 7)
	make_room(210, 204, -148, -162, 447.5, 447.5, 447.5, 447.5, 7)

	-- room 204
	make_room(140, 135, -143, -151, 447.5, 447.5, 447.5, 447.5, 8)
	make_room(156, 150, -143, -147, 447.5, 447.5, 447.5, 447.5, 8)
	make_room(168, 161, -143, -148, 447.5, 447.5, 447.5, 447.5, 8)
	make_room(168, 161, -171, -176, 447.5, 447.5, 447.5, 447.5, 8)

	-- room 205
	make_room(105, 98, -143, -148, 447.5, 447.5, 447.5, 447.5, 14)
	make_room(131, 123, -143, -147, 447.5, 447.5, 447.5, 447.5, 14)
	make_room(131, 117, -158, -164, 447.5, 447.5, 447.5, 447.5, 14)

	-- room 206
	make_room(42, 37, -143, -151, 447.5, 447.5, 447.5, 447.5, 13)
	make_room(58, 52, -143, -147, 447.5, 447.5, 447.5, 447.5, 13)
	make_room(70, 63, -143, -158, 447.5, 447.5, 447.5, 447.5, 13)

	-- room 207
	make_room(7, 0, -143, -148, 447.5, 447.5, 447.5, 447.5, 80)
	make_room(33, 27, -143, -148, 447.5, 447.5, 447.5, 447.5, 80)
	make_room(33, 19, -158, -164, 447.5, 447.5, 447.5, 447.5, 80)
end
