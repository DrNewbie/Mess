if Network:is_client() then
	return
end

_G.NoSenseGate = _G.NoSenseGate or {}

NoSenseGate.Loadad = 0

function NoSenseGate:Spawn_the_Gate(door)
	math.randomseed(os.time())
	DelayedCalls:Add("DelayedModSpawn_the_Gate", 1, function()
		local _unit_name = Idstring("units/payday2/architecture/bnk/bnk_int_window_office_a")
		for x = 1, 50 do
			for y = 1, 50 do
				safe_spawn_unit(_unit_name, Vector3(1620, -1080, 3000) + Vector3(0, 140*y, 0) + Vector3(-200*x, 0, 0), Rotation(0, 0, 90))
			end
		end
		local _r = {0, 45, 20, 70, -20, -70, -45}
		for x = 1, 500 do
			safe_spawn_unit(_unit_name, Vector3(math.random(-8000, 1200), math.random(-800, 5800), 3020), Rotation(_r[math.random(1, 7)], 0, 0))
		end
	end)
end

NoSenseGate.Loadad = 1

Announcer:AddHostMod("Glass Attack , A Game Mode , shoot the glass and make others fall down")