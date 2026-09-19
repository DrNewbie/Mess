local player_unit = managers.player:player_unit()
if player_unit then
	--log(tostring(player_unit:position()))
	--Vector3(-8353.92, -6496.32, -2018.9)
	--Vector3(1042.14, -6475.62, -2018.9)
	local _pos_offset = function (i)
		local ang = math.random() * 360 * math.pi * i
		local rad = math.random(30, 50)
		return Vector3(math.cos(ang) * rad, math.sin(ang) * rad, 0)
	end
	local now_pos_bomb = Vector3(-8300, -6475, 8000)
	local end_pos = Vector3(1000, -6475, 8000)
	local now_i = 1
	while mvector3.distance(now_pos_bomb, end_pos) > 100 do
		local tmp_pos = now_pos_bomb + _pos_offset(now_i)
		DelayedCalls:Add('F_'..Idstring('ClusterMolotovBombPlus_'.. tostring(player_unit:key()) ..'_' .. now_i):key(), now_i*0.05, function()
			ProjectileBase.throw_projectile("molotov", tmp_pos, Vector3(math.random() - 0.5, math.random() - 0.5, -1))
		end)
		now_pos_bomb = now_pos_bomb + Vector3(20, 0, 0)
		now_i = now_i + 1
	end
end