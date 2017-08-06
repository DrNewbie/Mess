if Network:is_client() then
	return
end

_G.NoSenseGate = _G.NoSenseGate or {}

NoSenseGate.Loadad = 0

function NoSenseGate:Spawn_the_Gate(door)
	DelayedCalls:Add("DelayedModSpawn_the_Gate", 1, function()
		local bnk_int_fence_door_interactable = "units/payday2/architecture/bnk/bnk_int_fence_door_interactable"
		local bnk_int_fence_gate = "units/payday2/architecture/bnk/bnk_int_fence_gate"
		local bnk_int_fence_wall_short = "units/payday2/architecture/bnk/bnk_int_fence_wall_short"

		local spawn_list = {
			block_drill = {
				unit = bnk_int_fence_door_interactable,
				pos = Vector3(-4040, 2250, 0),
				rot = Rotation(-90, 0, 0),
				group = {
					{ unit = bnk_int_fence_gate, pos_fix = Vector3(0, -50, 0) },
					{ unit = bnk_int_fence_wall_short, pos_fix = Vector3(0, 150, 0) },
					{ unit = bnk_int_fence_wall_short, pos_fix = Vector3(0, 250, 0) },
					{ unit = bnk_int_fence_wall_short, pos_fix = Vector3(0, 350, 0) },
					{ unit = bnk_int_fence_wall_short, pos_fix = Vector3(0, 450, 0) },
					{ unit = bnk_int_fence_wall_short, pos_fix = Vector3(0, -150, 0) },
					{ unit = bnk_int_fence_wall_short, pos_fix = Vector3(0, -250, 0) },
					{ unit = bnk_int_fence_wall_short, pos_fix = Vector3(0, -350, 0) },
					{ unit = bnk_int_fence_wall_short, pos_fix = Vector3(0, -450, 0) },
					{ unit = bnk_int_fence_wall_short, pos_fix = Vector3(0, -550, 0) },
					{ unit = bnk_int_fence_wall_short, pos_fix = Vector3(0, -650, 0) },
					{ unit = bnk_int_fence_wall_short, pos_fix = Vector3(0, -750, 0) },
					{ unit = bnk_int_fence_wall_short, pos_fix = Vector3(0, -850, 0) },
					{ unit = bnk_int_fence_wall_short, pos_fix = Vector3(0, -950, 0) },
					{ unit = bnk_int_fence_wall_short, pos_fix = Vector3(0, -1050, 0) },
					{ unit = bnk_int_fence_wall_short, pos_fix = Vector3(100, -1050, 0), rot = Rotation(0, 0, 0) },
					{ unit = bnk_int_fence_wall_short, pos_fix = Vector3(200, -1050, 0), rot = Rotation(0, 0, 0) },
					{ unit = bnk_int_fence_wall_short, pos_fix = Vector3(300, -1050, 0), rot = Rotation(0, 0, 0) },
					{ unit = bnk_int_fence_wall_short, pos_fix = Vector3(400, -1050, 0), rot = Rotation(0, 0, 0) },
					{ unit = bnk_int_fence_wall_short, pos_fix = Vector3(500, -1050, 0), rot = Rotation(0, 0, 0) },
					{ unit = bnk_int_fence_wall_short, pos_fix = Vector3(600, -1050, 0), rot = Rotation(0, 0, 0) },
					{ unit = bnk_int_fence_wall_short, pos_fix = Vector3(700, -1050, 0), rot = Rotation(0, 0, 0) },
					{ unit = bnk_int_fence_wall_short, pos_fix = Vector3(800, -1050, 0), rot = Rotation(0, 0, 0) },
					{ unit = bnk_int_fence_wall_short, pos_fix = Vector3(900, -1050, 0), rot = Rotation(0, 0, 0) },
					{ unit = bnk_int_fence_wall_short, pos_fix = Vector3(100, 550, 0), rot = Rotation(0, 0, 0) },
					{ unit = bnk_int_fence_wall_short, pos_fix = Vector3(200, 550, 0), rot = Rotation(0, 0, 0) },
					{ unit = bnk_int_fence_wall_short, pos_fix = Vector3(300, 550, 0), rot = Rotation(0, 0, 0) },
					{ unit = bnk_int_fence_wall_short, pos_fix = Vector3(400, 550, 0), rot = Rotation(0, 0, 0) },
					{ unit = bnk_int_fence_wall_short, pos_fix = Vector3(500, 550, 0), rot = Rotation(0, 0, 0) },
					{ unit = bnk_int_fence_wall_short, pos_fix = Vector3(600, 550, 0), rot = Rotation(0, 0, 0) },
					{ unit = bnk_int_fence_wall_short, pos_fix = Vector3(700, 550, 0), rot = Rotation(0, 0, 0) },
					{ unit = bnk_int_fence_wall_short, pos_fix = Vector3(800, 550, 0), rot = Rotation(0, 0, 0) },
					{ unit = bnk_int_fence_wall_short, pos_fix = Vector3(900, 550, 0), rot = Rotation(0, 0, 0) }
				}
			},
			{
				unit = bnk_int_fence_door_interactable,
				pos = Vector3(-6950, -1700, -20),
				rot = Rotation(180, 0, 0),
				group = {
					{ unit = bnk_int_fence_gate, pos_fix = Vector3(-50, 0, 0) },
					{ unit = bnk_int_fence_wall_short, pos_fix = Vector3(150, 0, 0) },
					{ unit = bnk_int_fence_wall_short, pos_fix = Vector3(250, 0, 0) },
					{ unit = bnk_int_fence_wall_short, pos_fix = Vector3(350, 0, 0) },
					{ unit = bnk_int_fence_wall_short, pos_fix = Vector3(450, 0, 0) },
					{ unit = bnk_int_fence_wall_short, pos_fix = Vector3(550, 0, 0) },
					{ unit = bnk_int_fence_wall_short, pos_fix = Vector3(650, 0, 0) },
					{ unit = bnk_int_fence_wall_short, pos_fix = Vector3(750, 0, 0) },
					{ unit = bnk_int_fence_wall_short, pos_fix = Vector3(850, 0, 0) },
					{ unit = bnk_int_fence_wall_short, pos_fix = Vector3(950, 0, 0) },
					{ unit = bnk_int_fence_wall_short, pos_fix = Vector3(-150, 0, 0) },
					{ unit = bnk_int_fence_wall_short, pos_fix = Vector3(-250, 0, 0) },
					{ unit = bnk_int_fence_wall_short, pos_fix = Vector3(-350, 0, 0) },
					{ unit = bnk_int_fence_wall_short, pos_fix = Vector3(-450, 0, 0) },
					{ unit = bnk_int_fence_wall_short, pos_fix = Vector3(-550, 0, 0) },
					{ unit = bnk_int_fence_wall_short, pos_fix = Vector3(-650, 0, 0) },
					{ unit = bnk_int_fence_wall_short, pos_fix = Vector3(-750, 0, 0) },
					{ unit = bnk_int_fence_wall_short, pos_fix = Vector3(-850, 0, 0) },
					{ unit = bnk_int_fence_wall_short, pos_fix = Vector3(-950, 0, 0) },
					{ unit = bnk_int_fence_wall_short, pos_fix = Vector3(-1050, 0, 0) }
				}
			},
			{
				unit = bnk_int_fence_door_interactable,
				pos = Vector3(-1050, -1900, 0),
				rot = Rotation(180, 0, 0),
				group = {
					{ unit = bnk_int_fence_gate, pos_fix = Vector3(-50, 0, 0) },
					{ unit = bnk_int_fence_wall_short, pos_fix = Vector3(150, 0, 0) },
					{ unit = bnk_int_fence_wall_short, pos_fix = Vector3(-150, 0, 0) },
					{ unit = bnk_int_fence_wall_short, pos_fix = Vector3(-150, 0, 300) },
					{ unit = bnk_int_fence_wall_short, pos_fix = Vector3(-50, 0, 300) },
					{ unit = bnk_int_fence_wall_short, pos_fix = Vector3(50, 0, 300) },
					{ unit = bnk_int_fence_wall_short, pos_fix = Vector3(150, 0, 300) }
				}
			},
			{
				unit = bnk_int_fence_door_interactable,
				pos = Vector3(2045, 3550, 0),
				rot = Rotation(-90, 0, 0),
				group = {
					{ unit = bnk_int_fence_gate, pos_fix = Vector3(0, -50, 0) },
					{ unit = bnk_int_fence_wall_short, pos_fix = Vector3(0, 150, 0) },
					{ unit = bnk_int_fence_wall_short, pos_fix = Vector3(0, -150, 0) },
					{ unit = bnk_int_fence_wall_short, pos_fix = Vector3(0, -250, 0) },
					{ unit = bnk_int_fence_wall_short, pos_fix = Vector3(0, -250, 300) },
					{ unit = bnk_int_fence_wall_short, pos_fix = Vector3(0, -150, 300) },
					{ unit = bnk_int_fence_wall_short, pos_fix = Vector3(0, -50, 300) },
					{ unit = bnk_int_fence_wall_short, pos_fix = Vector3(0, 50, 300) },
					{ unit = bnk_int_fence_wall_short, pos_fix = Vector3(0, 150, 300) }
				}
			},
			{
				unit = bnk_int_fence_door_interactable,
				pos = Vector3(-900, 2600, 0),
				rot = Rotation(0, 0, 0),
				group = {
					{ unit = bnk_int_fence_wall_short, pos_fix = Vector3(100, 0, 0) },
				},
			},
			{
				unit = bnk_int_fence_door_interactable,
				pos = Vector3(-1010, 2700, 0),
				rot = Rotation(90, 0, 0),
				group = {
					{ unit = bnk_int_fence_wall_short, pos_fix = Vector3(0, 100, 0) },
					{ unit = bnk_int_fence_wall_short, pos_fix = Vector3(0, 200, 0) },
				},
			},
			{
				unit = bnk_int_fence_door_interactable,
				pos = Vector3(-1350, 2000, 4),
				rot = Rotation(180, 0, 0)
			},
			{
				unit = bnk_int_fence_door_interactable,
				pos = Vector3(-1850, 1600, 4),
				rot = Rotation(180, 0, 0)
			},
			{
				unit = bnk_int_fence_wall_short,
				pos = Vector3(-2845, -20, 267),
				rot = Rotation(0, 0, 0)
			},
			{
				unit = bnk_int_fence_wall_short,
				pos = Vector3(-2945, -20, 267),
				rot = Rotation(0, 0, 0)
			},
			{
				unit = bnk_int_fence_wall_short,
				pos = Vector3(-3045, -20, 267),
				rot = Rotation(0, 0, 0)
			},
			{
				unit = bnk_int_fence_wall_short,
				pos = Vector3(-3145, -20, 267),
				rot = Rotation(0, 0, 0)
			},
			{
				unit = bnk_int_fence_wall_short,
				pos = Vector3(-2825, 1195, 465),
				rot = Rotation(90, 0, 0)
			},
			{
				unit = bnk_int_fence_wall_short,
				pos = Vector3(-2825, 1095, 465),
				rot = Rotation(90, 0, 0)
			},
			{
				unit = bnk_int_fence_wall_short,
				pos = Vector3(-2825, 995, 465),
				rot = Rotation(90, 0, 0)
			},
			{
				unit = bnk_int_fence_wall_short,
				pos = Vector3(-2825, 895, 465),
				rot = Rotation(90, 0, 0)
			},
			{
				unit = bnk_int_fence_wall_short,
				pos = Vector3(-2195, 0, 465),
				rot = Rotation(0, 90, 0),
			},
			{
				unit = bnk_int_fence_wall_short,
				pos = Vector3(-2195, -300, 465),
				rot = Rotation(0, 90, 0),
			},
			{
				unit = bnk_int_fence_wall_short,
				pos = Vector3(-2195, -600, 465),
				rot = Rotation(0, 90, 0),
			},
			{
				unit = bnk_int_fence_wall_short,
				pos = Vector3(-2195, -900, 465),
				rot = Rotation(0, 90, 0),
			},
			{
				unit = bnk_int_fence_wall_short,
				pos = Vector3(-2195, -1100, 465),
				rot = Rotation(90, 70, 0),
			},
			{
				unit = bnk_int_fence_wall_short,
				pos = Vector3(-1912, -1100, 568),
				rot = Rotation(90, 70, 0),
			},
			{
				unit = bnk_int_fence_wall_short,
				pos = Vector3(-1629, -1100, 671),
				rot = Rotation(90, 70, 0),
			},
			{
				unit = bnk_int_fence_wall_short,
				pos = Vector3(-1346, -1100, 774),
				rot = Rotation(90, 70, 0),
			},
			{
				unit = bnk_int_fence_wall_short,
				pos = Vector3(-1063, -1100, 877),
				rot = Rotation(90, 90, 0),
			},
			{
				unit = bnk_int_fence_wall_short,
				pos = Vector3(-763, -1200, 877),
				rot = Rotation(0, 90, 0),
			},
			{
				unit = bnk_int_fence_wall_short,
				pos = Vector3(-763, -1600, 877),
				rot = Rotation(-90, 90, 0),
			},
			{
				unit = bnk_int_fence_wall_short,
				pos = Vector3(-1063, -1600, 877),
				rot = Rotation(-90, 90, 0),
			},
			{
				unit = bnk_int_fence_wall_short,
				pos = Vector3(-1630, -1600, 770),
				rot = Rotation(-90, -70, 0),
			},
			{
				unit = bnk_int_fence_wall_short,
				pos = Vector3(-1913, -1600, 671),
				rot = Rotation(-90, -70, 0),
			},
			{
				unit = bnk_int_fence_wall_short,
				pos = Vector3(-2196, -1600, 568),
				rot = Rotation(-90, -70, 0),
			},
			{
				unit = bnk_int_fence_wall_short,
				pos = Vector3(-2479, -1600, 465),
				rot = Rotation(-90, -70, 0),
			},
			{
				unit = bnk_int_fence_wall_short,
				pos = Vector3(-2762, -1600, 362),
				rot = Rotation(-90, -70, 0),
			},
			{
				unit = bnk_int_fence_wall_short,
				pos = Vector3(-3045, -1600, 259),
				rot = Rotation(-90, -70, 0),
			},
			{
				unit = bnk_int_fence_wall_short,
				pos = Vector3(-3328, -1600, 156),
				rot = Rotation(-90, -70, 0),
			},
			{
				unit = bnk_int_fence_wall_short,
				pos = Vector3(-3611, -1600, 53),
				rot = Rotation(-90, -70, 0),
			},
			{
				unit = bnk_int_fence_wall_short,
				pos = Vector3(-3894, -1600, -50),
				rot = Rotation(-90, -70, 0),
			}
		}
		local bank_gate_front = {
			unit = bnk_int_fence_door_interactable,
			pos = Vector3(-2150, 1400, 0),
			rot = Rotation(0, 0, 0),
			group = {
				{ unit = bnk_int_fence_gate, pos_fix = Vector3(50, 0, 0) },
				{ unit = bnk_int_fence_wall_short, pos_fix = Vector3(160, 0, 0), },
				{ unit = bnk_int_fence_wall_short, pos_fix = Vector3(160, 0, 0), rot = Rotation(-90, 0, 0) },
				{ unit = bnk_int_fence_wall_short, pos_fix = Vector3(160, 100, 0), rot = Rotation(-90, 0, 0) },
				{ unit = bnk_int_fence_wall_short, pos_fix = Vector3(-160, 0, 0), },
				{ unit = bnk_int_fence_wall_short, pos_fix = Vector3(-260, 0, 0), rot = Rotation(-90, 0, 0) },
				{ unit = bnk_int_fence_wall_short, pos_fix = Vector3(-260, 100, 0), rot = Rotation(-90, 0, 0) },
			}
		}
		local bank_gate_back = {
			unit = bnk_int_fence_door_interactable,
			pos = Vector3(-1355, 2250, 0),
			rot = Rotation(90, 0, 0),
			group = {
				{ unit = bnk_int_fence_gate, pos_fix = Vector3(0, 50, 0) },
				{ unit = bnk_int_fence_wall_short, pos_fix = Vector3(0, -150, 0), },
				{ unit = bnk_int_fence_wall_short, pos_fix = Vector3(0, 150, 0), },
			}
		}
		if door == "100718" then
			table.insert(spawn_list, bank_gate_back)
		else
			table.insert(spawn_list, bank_gate_front)
		end
		local _u = nil
		for k, v in pairs(spawn_list) do
			if v.unit then
				local _u = safe_spawn_unit(Idstring(v.unit), v.pos, v.rot)
				NoSenseGate:Sync_Send("Sync_Spawn", _u:name():key() .. ";" .. get_xyz_yawpitchroll(_u))
				if v.unit == bnk_int_fence_door_interactable then
					_u:base():activate()
				end
			end
			if v.group then
				for k2, v2 in pairs(v.group) do
					_u = safe_spawn_unit(Idstring(v2.unit), v.pos + v2.pos_fix, v2.rot or v.rot)
					NoSenseGate:Sync_Send("Sync_Spawn", _u:name():key() .. ";" .. get_xyz_yawpitchroll(_u))
				end
			end
		end
	end)
end

function get_xyz_yawpitchroll(_unit)
	if _unit then
		local _x = math.floor(_unit:position().x)
		local _y = math.floor(_unit:position().y)
		local _z = math.floor(_unit:position().z)
		local _yaw = math.floor(_unit:rotation():yaw())
		local _pitch = math.floor(_unit:rotation():pitch())
		local _roll = math.floor(_unit:rotation():roll())
		local _pos = _x .. "," .. _y .. "," .. _z
		local _rot = _yaw .. "," .. _pitch .. "," .. _roll
		return (_pos .. ";" .. _rot)
	end
	return
end

NoSenseGate.Loadad = 1