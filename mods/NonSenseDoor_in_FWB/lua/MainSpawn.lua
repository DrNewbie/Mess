if Network:is_client() then
	return
end

_G.NoSenseDoor = _G.NoSenseDoor or {}

NoSenseDoor.Loadad = 0

function NoSenseDoor:Spawn_the_Door(door)
	DelayedCalls:Add("DelayedModSpawn_the_Door", 1, function()
		local _door_unit_name = "units/payday2/equipment/gen_interactable_door_reinforced/gen_interactable_door_reinforced"
		local spawn_list = {}
		if door then
			spawn_list = door
		else
			spawn_list = {
				first_enter_door_a1 = {pos = Vector3(-2880, -470, 8), rot = Rotation(180, 0, 0)},
				first_enter_door_a2 = {pos = Vector3(-2880, -370, 8), rot = Rotation(180, 0, 0)},
				first_enter_door_a3 = {pos = Vector3(-2880, -270, 8), rot = Rotation(180, 0, 0)},
				
				first_enter_door_b1 = {pos = Vector3(-2880, -20, 8), rot = Rotation(180, 0, 0)},
				first_enter_door_b2 = {pos = Vector3(-2880, 80, 8), rot = Rotation(180, 0, 0)},
				first_enter_door_b3 = {pos = Vector3(-2880, 180, 8), rot = Rotation(180, 0, 0)},
				
				first_enter_door_c1 = {pos = Vector3(-2880, 420, 8), rot = Rotation(180, 0, 0)},
				first_enter_door_c2 = {pos = Vector3(-2880, 520, 8), rot = Rotation(180, 0, 0)},
				first_enter_door_c3 = {pos = Vector3(-2880, 620, 8), rot = Rotation(180, 0, 0)},
				
				possible_keycard_door_1 = {pos = Vector3(890, 1950, 475), rot = Rotation(180, 0, 0)},
				
				possible_keycard_door_2_a1 = {pos = Vector3(930, -1400, 475), rot = Rotation(90, 0, 0)},
				possible_keycard_door_2_a2 = {pos = Vector3(830, -1400, 475), rot = Rotation(90, 0, 0)},
				possible_keycard_door_2_a3 = {pos = Vector3(730, -1400, 475), rot = Rotation(90, 0, 0)},
				possible_keycard_door_2_a4 = {pos = Vector3(630, -1400, 475), rot = Rotation(90, 0, 0)},
				
				possible_keycard_door_2_b1 = {pos = Vector3(-955, -2500, 475), rot = Rotation(90, 0, 0)},
				possible_keycard_door_2_b2 = {pos = Vector3(-1055, -2500, 475), rot = Rotation(90, 0, 0)},
				
				block_possible_keycard_door_1 = {pos = Vector3(1000, -2740, 475), rot = Rotation(0, 0, 0)},
				block_possible_keycard_door_2 = {pos = Vector3(1310, 2470, 475), rot = Rotation(0, 0, 0)},
				
				possible_man_1_a1 = {pos = Vector3(-1750, -2740, 475), rot = Rotation(0, 0, 0)},
				possible_man_1_a2 = {pos = Vector3(-1750, -2840, 475), rot = Rotation(0, 0, 0)},
				
				possible_man_2 = {pos = Vector3(-620, -3035, 480), rot = Rotation(90, 0, 0)},

				go_to_2F_1_a1 = {pos = Vector3(870, 2100, 475), rot = Rotation(90, 0, 0)},
				go_to_2F_1_a2 = {pos = Vector3(770, 2100, 475), rot = Rotation(90, 0, 0)},
				go_to_2F_1_a3 = {pos = Vector3(670, 2100, 475), rot = Rotation(90, 0, 0)},
				
				go_to_2F_1_b1 = {pos = Vector3(870, 2350, 360), rot = Rotation(90, 0, 0)},
				go_to_2F_1_b2 = {pos = Vector3(770, 2350, 360), rot = Rotation(90, 0, 0)},
				go_to_2F_1_b3 = {pos = Vector3(670, 2350, 360), rot = Rotation(90, 0, 0)},
				
				go_to_2F_1_c1 = {pos = Vector3(870, 2600, 225), rot = Rotation(90, 0, 0)},
				go_to_2F_1_c2 = {pos = Vector3(770, 2600, 225), rot = Rotation(90, 0, 0)},
				go_to_2F_1_c3 = {pos = Vector3(670, 2600, 225), rot = Rotation(90, 0, 0)},
				
				last_camera_block_a1 = {pos = Vector3(6200, 1200, -75), rot = Rotation(180, 0, 0)},
				last_camera_block_a2 = {pos = Vector3(6200, 1300, -75), rot = Rotation(180, 0, 0)},
				last_camera_block_a3 = {pos = Vector3(6200, 1400, -75), rot = Rotation(180, 0, 0)},
				
				goto_last_camera_block_a1 = {pos = Vector3(3130, 680, -13), rot = Rotation(180, 0, 0)},
				goto_last_camera_block_a2 = {pos = Vector3(3130, 780, -13), rot = Rotation(180, 0, 0)},
				goto_last_camera_block_a3 = {pos = Vector3(3130, 880, -13), rot = Rotation(180, 0, 0)},
				
				goto_last_camera_block_b1 = {pos = Vector3(3130, 1950, -13), rot = Rotation(180, 0, 0)},
				goto_last_camera_block_b2 = {pos = Vector3(3130, 1850, -13), rot = Rotation(180, 0, 0)},
				goto_last_camera_block_b3 = {pos = Vector3(3130, 1750, -13), rot = Rotation(180, 0, 0)},
				
				vault_go_out_block_1 = {pos = Vector3(5920, 1550, -425), rot = Rotation(180, 0, 0)},
				vault_go_out_block_2 = {pos = Vector3(5920, 1450, -425), rot = Rotation(180, 0, 0)},
				vault_go_out_block_3 = {pos = Vector3(5920, 1350, -425), rot = Rotation(180, 0, 0)},
				vault_go_out_block_4 = {pos = Vector3(5920, 1250, -425), rot = Rotation(180, 0, 0)},
				vault_go_out_block_5 = {pos = Vector3(5920, 1150, -425), rot = Rotation(180, 0, 0)},
				vault_go_out_block_6 = {pos = Vector3(5920, 1050, -425), rot = Rotation(180, 0, 0)},
				
				vault_go_in_block_a1 = {pos = Vector3(7300, 1550, -425), rot = Rotation(180, 0, 0)},
				vault_go_in_block_a2 = {pos = Vector3(7300, 1450, -425), rot = Rotation(180, 0, 0)},
				vault_go_in_block_a3 = {pos = Vector3(7300, 1350, -425), rot = Rotation(180, 0, 0)},
				vault_go_in_block_a4 = {pos = Vector3(7300, 1250, -425), rot = Rotation(180, 0, 0)},
				vault_go_in_block_a5 = {pos = Vector3(7300, 1150, -425), rot = Rotation(180, 0, 0)},
				vault_go_in_block_a6 = {pos = Vector3(7300, 1050, -425), rot = Rotation(180, 0, 0)},
				
				vault_go_in_block_b1 = {pos = Vector3(7130, 1540, -435), rot = Rotation(90, 0, 0)},
				vault_go_in_block_b2 = {pos = Vector3(7230, 1540, -435), rot = Rotation(90, 0, 0)},
				vault_go_in_block_b3 = {pos = Vector3(7330, 1540, -435), rot = Rotation(90, 0, 0)},
				
				vault_go_in_block_c1 = {pos = Vector3(6625, 1940, -433), rot = Rotation(180, 0, 0)},
				vault_go_in_block_c2 = {pos = Vector3(6625, 1840, -433), rot = Rotation(180, 0, 0)},
				vault_go_in_block_c3 = {pos = Vector3(6625, 1740, -433), rot = Rotation(180, 0, 0)},
				vault_go_in_block_c4 = {pos = Vector3(6625, 1640, -433), rot = Rotation(180, 0, 0)},
				vault_go_in_block_c5 = {pos = Vector3(6625, 1540, -433), rot = Rotation(180, 0, 0)},
				
				escape_block_1 = {pos = Vector3(800, -3050, 475), rot = Rotation(90, 0, 0)},
				escape_block_2 = {pos = Vector3(5610, -2565, 465), rot = Rotation(-90, 0, 0)},
				
				escape_block_annoy_1 = {pos = Vector3(4570, 355, -735), rot = Rotation(0, 0, 0)},
				escape_block_annoy_2 = {pos = Vector3(4570, 255, -735), rot = Rotation(0, 0, 0)},
				escape_block_annoy_3 = {pos = Vector3(4570, 155, -735), rot = Rotation(0, 0, 0)},
				escape_block_annoy_4 = {pos = Vector3(4770, 355, -735), rot = Rotation(0, 0, 0)},
				escape_block_annoy_5 = {pos = Vector3(4770, 255, -735), rot = Rotation(0, 0, 0)},
				escape_block_annoy_6 = {pos = Vector3(4770, 155, -735), rot = Rotation(0, 0, 0)},
				escape_block_annoy_7 = {pos = Vector3(4970, 355, -735), rot = Rotation(0, 0, 0)},
				escape_block_annoy_8 = {pos = Vector3(4970, 255, -735), rot = Rotation(0, 0, 0)},
				escape_block_annoy_9 = {pos = Vector3(4970, 155, -735), rot = Rotation(0, 0, 0)},
				escape_block_annoy_10 = {pos = Vector3(5170, 355, -735), rot = Rotation(0, 0, 0)},
				escape_block_annoy_11 = {pos = Vector3(5170, 255, -735), rot = Rotation(0, 0, 0)},
				escape_block_annoy_12 = {pos = Vector3(5170, 155, -735), rot = Rotation(0, 0, 0)},
				escape_block_annoy_13 = {pos = Vector3(5370, 355, -735), rot = Rotation(0, 0, 0)},
				escape_block_annoy_14 = {pos = Vector3(5370, 255, -735), rot = Rotation(0, 0, 0)},
				escape_block_annoy_15 = {pos = Vector3(5370, 155, -735), rot = Rotation(0, 0, 0)},
			}
		end

		local _u = nil
		for k, v in pairs(spawn_list) do
			if v.pos and v.rot then
				local _u = safe_spawn_unit(Idstring(_door_unit_name), v.pos, v.rot)
				if not v.no_active then
					_u:base():activate()
				end
			end
		end
	end)
end

NoSenseDoor.Loadad = 1