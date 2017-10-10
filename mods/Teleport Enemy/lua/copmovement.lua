_G._WTF_Fly_Enemy_Big = _G._WTF_Fly_Enemy_Big or 0

local function rand_vector3_use(pos)
	local _use_v3_list = {pos}
	local z_offsett = {0, 0, 100, 0, 300, 400, 200, 500, 500}
	local _offset = Vector3(math.random(-800, 800), math.random(-800, 800), z_offsett[math.random(#z_offsett)]) 
	for _, data in pairs(managers.groupai:state():all_player_criminals()) do
		table.insert(_use_v3_list, data.unit:position())
	end
	pos = _use_v3_list[math.random(#_use_v3_list)]
	pos = pos + _offset
	return pos
end

Hooks:PostHook(CopMovement, "post_init", "CopMovement_post_init_WTF_Fly_Enemy", function(self, ...)
	self._WTF_Fly_Enemy_delay_t = 0
	self._WTF_Fly_Enemy_warp2 = nil
end)

Hooks:PostHook(CopMovement, "update", "CopMovement_update_WTF_Fly_Enemy", function(self, unit, t, dt)
	if self._WTF_Fly_Enemy_delay_t > t or _WTF_Fly_Enemy_Big > t then
		return
	end
	_WTF_Fly_Enemy_Big = t + 0.2
	if self._WTF_Fly_Enemy_warp2 then
		self:action_request({
			body_part = 1,
			type = "warp",
			position = self._WTF_Fly_Enemy_warp2,
			rotation = self._m_rot
		})
		self._WTF_Fly_Enemy_warp2 = nil
		return
	end
	local _randomseed = tostring(os.time()):reverse():sub(1, 6) .. tostring(_WTF_Fly_Enemy_Big)
	math.randomseed(_randomseed)	
	self._WTF_Fly_Enemy_delay_t = t + 3 + math.random()*10
	
	local enemyType = tostring(self._unit:base()._tweak_table)
	local enemyTypeList = {
		"security",
		"gensec",
		"cop",
		"fbi",
		"swat",
		"heavy_swat",
		"fbi_swat",
		"fbi_heavy_swat",
		"city_swat",
		"sniper",
		"gangster",
		"taser",
		"tank",
		"spooc",
		"shield",
		"medic"
	}
	local _in_list = table.contains(enemyTypeList, enemyType) and true or false
	local _is_enemy = managers.enemy:is_enemy(self._unit) and true or false
	local _is_converted = self._ext_brain and self._ext_brain._logic_data.is_converted and true or false
	local _dead = self._ext_damage and self._ext_damage:dead() and true or false
	local _immortal = self._ext_damage and self._ext_damage.immortal and true or false
	local _invulnerable = self._ext_damage and self._ext_damage._invulnerable and true or false
	if _in_list and _is_enemy and not _is_converted and not _dead and not _immortal and not _invulnerable then
		self._WTF_Fly_Enemy_warp2 = rand_vector3_use(self._m_pos)
	end
end)