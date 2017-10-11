_G._WTF_Fly_Enemy_Index = _G._WTF_Fly_Enemy_Index or 0

Hooks:PostHook(CopMovement, "post_init", "CopMovement_post_init_WTF_Fly_Enemy", function(self, ...)
	self._WTF_Fly_Enemy_delay_t = 0
end)

Hooks:PostHook(CopMovement, "update", "CopMovement_update_WTF_Fly_Enemy", function(self, unit, t, dt)
	if self._WTF_Fly_Enemy_delay_t > t then
		return
	end
	local _randomseed = tostring(os.time()):reverse():sub(1, 6) .. tostring(t)
	math.randomseed(_randomseed)	
	self._WTF_Fly_Enemy_delay_t = t + 9 + math.random()*10
	
	local enemyType = tostring(self._unit:base()._tweak_table)
	local enemyTypeList = {
		"security", "gensec", "cop", "fbi", "swat", "heavy_swat", "fbi_swat",
		"fbi_heavy_swat", "city_swat", "sniper", "gangster", "taser", "tank",
		"spooc", "shield", "medic"
	}
	local _in_list = table.contains(enemyTypeList, enemyType) and true or false
	local _is_enemy = managers.enemy:is_enemy(self._unit) and true or false
	local _is_converted = self._ext_brain and self._ext_brain._logic_data.is_converted and true or false
	local _dead = self._ext_damage and self._ext_damage:dead() and true or false
	local _immortal = self._ext_damage and self._ext_damage.immortal and true or false
	local _invulnerable = self._ext_damage and self._ext_damage._invulnerable and true or false
	if _in_list and _is_enemy and not _is_converted and not _dead and not _immortal and not _invulnerable then
		local _rand_vector3_use = function(pos)
			local _use_v3_list = {pos}
			local xy_offset = {
				Vector3(0, 0, 0), Vector3(0, -100, 0), Vector3(0, -300, 0), Vector3(0, -500, 0), Vector3(0, -700, 0), Vector3(0, -900, 0), Vector3(100, 0, 0), Vector3(100, -100, 0), Vector3(100, -300, 0), Vector3(100, -500, 0), Vector3(100, -700, 0), Vector3(100, -900, 0), Vector3(300, 0, 0), Vector3(300, -100, 0), Vector3(300, -300, 0), Vector3(300, -500, 0), Vector3(300, -700, 0), Vector3(300, -900, 0), Vector3(500, 0, 0), Vector3(500, -100, 0), Vector3(500, -300, 0), Vector3(500, -500, 0), Vector3(500, -700, 0), Vector3(500, -900, 0), Vector3(700, 0, 0), Vector3(700, -100, 0), Vector3(700, -300, 0), Vector3(700, -500, 0), Vector3(700, -700, 0), Vector3(700, -900, 0), Vector3(900, 0, 0), Vector3(900, -100, 0), Vector3(900, -300, 0), Vector3(900, -500, 0), Vector3(900, -700, 0), Vector3(900, -900, 0),
				Vector3(0, 100, 0), Vector3(0, 300, 0), Vector3(0, 500, 0), Vector3(0, 700, 0), Vector3(0, 900, 0), Vector3(-100, 0, 0), Vector3(-100, 100, 0), Vector3(-100, 300, 0), Vector3(-100, 500, 0), Vector3(-100, 700, 0), Vector3(-100, 900, 0), Vector3(-300, 0, 0), Vector3(-300, 100, 0), Vector3(-300, 300, 0), Vector3(-300, 500, 0), Vector3(-300, 700, 0), Vector3(-300, 900, 0), Vector3(-500, 0, 0), Vector3(-500, 100, 0), Vector3(-500, 300, 0), Vector3(-500, 500, 0), Vector3(-500, 700, 0), Vector3(-500, 900, 0), Vector3(-700, 0, 0), Vector3(-700, 100, 0), Vector3(-700, 300, 0), Vector3(-700, 500, 0), Vector3(-700, 700, 0), Vector3(-700, 900, 0), Vector3(-900, 0, 0), Vector3(-900, 100, 0), Vector3(-900, 300, 0), Vector3(-900, 500, 0), Vector3(-900, 700, 0), Vector3(-900, 900, 0),
				Vector3(100, 100, 0), Vector3(100, 300, 0), Vector3(100, 500, 0), Vector3(100, 700, 0), Vector3(100, 900, 0), Vector3(300, 100, 0), Vector3(300, 300, 0), Vector3(300, 500, 0), Vector3(300, 700, 0), Vector3(300, 900, 0), Vector3(500, 100, 0), Vector3(500, 300, 0), Vector3(500, 500, 0), Vector3(500, 700, 0), Vector3(500, 900, 0), Vector3(700, 100, 0), Vector3(700, 300, 0), Vector3(700, 500, 0), Vector3(700, 700, 0), Vector3(700, 900, 0), Vector3(900, 100, 0), Vector3(900, 300, 0), Vector3(900, 500, 0), Vector3(900, 700, 0), Vector3(900, 900, 0),
				Vector3(-100, -100, 0), Vector3(-100, -300, 0), Vector3(-100, -500, 0), Vector3(-100, -700, 0), Vector3(-100, -900, 0), Vector3(-300, -100, 0), Vector3(-300, -300, 0), Vector3(-300, -500, 0), Vector3(-300, -700, 0), Vector3(-300, -900, 0), Vector3(-500, -100, 0), Vector3(-500, -300, 0), Vector3(-500, -500, 0), Vector3(-500, -700, 0), Vector3(-500, -900, 0), Vector3(-700, -100, 0), Vector3(-700, -300, 0), Vector3(-700, -500, 0), Vector3(-700, -700, 0), Vector3(-700, -900, 0), Vector3(-900, -100, 0), Vector3(-900, -300, 0), Vector3(-900, -500, 0), Vector3(-900, -700, 0), Vector3(-900, -900, 0)
			}
			local _pidx, _pidxt = 1, 1
			while true do
				_pidx = math.random(1, 121)
				if _pidx ~= _WTF_Fly_Enemy_Index then
					break
				end
				_pidxt = _pidxt + 1
				if _pidxt > 10 then
					_pidx = _WTF_Fly_Enemy_Index + 7
					if _pidx > 121 then
						_pidx = _pidx1 - 121
					end
					if _pidx > 121 then
						_pidx = 1
					end
					break
				end
			end
			local z_offset = {0, 0, 100, 0, 0, 0, 300, 400, 200, 500, 500}
			local _offset = xy_offset[_pidx] + Vector3(0, 0, z_offset[math.random(1, 11)]) 
			for _, data in pairs(managers.groupai:state():all_player_criminals()) do
				table.insert(_use_v3_list, data.unit:position())
			end
			pos = _use_v3_list[math.random(#_use_v3_list)]
			pos = pos + _offset
			return pos
		end
		local _warp2 = _rand_vector3_use(self._m_pos)
		self:action_request({
			body_part = 1,
			type = "warp",
			position = _warp2,
			rotation = self._m_rot
		})
	end
end)