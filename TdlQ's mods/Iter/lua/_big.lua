function itr_set_load_data(data, seg2vg)
	-- so _get_pos_on_wall() can find something when using thermite
	data.nav_segments[62].pos = Vector3(-3600, -1400, -1000)

	-- prevent chars to walk into wall
	data.room_borders_x_neg[489] = 66
	mvector3.set_x(data.door_low_pos[800], 66)
	mvector3.set_x(data.door_low_pos[801], 66)
end
