Hooks:PostHook(PlayerManager, "init", "Ply_"..Idstring("init ring of flames table"):key(), function(self)
	self._RingOfFlames_Table = {}
	self._RingOfFlames_Hits = {}
end)

function PlayerManager:GiveRingOfFlames()
	if not self._RingOfFlames_Time then
		self._RingOfFlames_Hits = {}
		self._RingOfFlames_Bool = true
		self._RingOfFlames_Time = 1
	end
end

local mvec1 = Vector3()

Hooks:PostHook(PlayerManager, "update", "Ply_"..Idstring("time loop for next ring of flames"):key(), function(self, t, dt)
	if self._RingOfFlames_Time and self:local_player() and self:local_player():movement() then
		self._RingOfFlames_Time = self._RingOfFlames_Time - dt
		if self._RingOfFlames_Time < 0 then
			self._RingOfFlames_Time = nil
			self._RingOfFlames_Bool = nil
		end
	end
end)

Hooks:PostHook(PlayerManager, "update", "Ply_"..Idstring("set ring of flames ohhhhhhhh"):key(), function(self, t, dt)
	if self._RingOfFlames_Bool and self:local_player() and self:local_player():movement() then
		self._RingOfFlames_Bool = nil
		local direction_list = {
			Vector3(1, 0, 0),
			Vector3(1, -1, 0),
			Vector3(0, -1, 0),
			Vector3(-1, -1, 0),
			Vector3(-1, 0, 0),
			Vector3(-1, 1, 0),
			Vector3(0, 1, 0),
			Vector3(1, 1, 0),
			Vector3(1, 0.5, 0),
			Vector3(0.5, 1, 0),
			Vector3(1, -0.5, 0),
			Vector3(0.5, -1, 0),
			Vector3(-1, -0.5, 0),
			Vector3(-0.5, -1, 0),
			Vector3(-1, 0.5, 0),
			Vector3(-0.5, 1, 0),
			Vector3(1, 0.25, 0),
			Vector3(0.25, 1, 0),
			Vector3(1, -0.25, 0),
			Vector3(0.25, -1, 0),
			Vector3(-1, -0.25, 0),
			Vector3(-0.25, -1, 0),
			Vector3(-1, 0.25, 0),
			Vector3(-0.25, 1, 0),
			Vector3(1, 0.75, 0),
			Vector3(0.75, 1, 0),
			Vector3(1, -0.75, 0),
			Vector3(0.75, -1, 0),
			Vector3(-1, -0.75, 0),
			Vector3(-0.75, -1, 0),
			Vector3(-1, 0.75, 0),
			Vector3(-0.75, 1, 0)
		}
		for i_dir = 1, #direction_list do
			local this_pos = self:local_player():position()
			local _flame_effect_id = World:effect_manager():spawn({
				effect = Idstring("effects/payday2/particles/explosions/flamethrower"),
				position = self:local_player():position(),
				normal = math.UP
			})
			table.insert(self._RingOfFlames_Table, {
				been_alive = true,
				id = _flame_effect_id,
				position = this_pos + Vector3(0, 0, 10),
				direction = direction_list[i_dir],
				this_pos = this_pos
			})
		end
	end
end)

Hooks:PostHook(PlayerManager, "update", "Ply_"..Idstring("and yes, it should be ring of flames around"):key(), function(self, t, dt)
	if self:local_player() and type(self._RingOfFlames_Table) == "table" then
		local flame_effect_max_dis = 800
		local flame_effect_dt = 3 / dt
		local flame_effect_distance = flame_effect_max_dis / flame_effect_dt
		for id, effect_entry in pairs(self._RingOfFlames_Table) do
			if effect_entry.been_alive and effect_entry.position and effect_entry.direction then
				local eff_pos = effect_entry.position
				local eff_dir = effect_entry.direction
				local eff_this_pos = effect_entry.this_pos
				mvector3.set(mvec1, eff_pos)
				mvector3.add(eff_pos, eff_dir * flame_effect_distance)
				World:effect_manager():move(effect_entry.id, eff_pos)
				local effect_distance = mvector3.distance(eff_pos, eff_this_pos)
				if flame_effect_max_dis < effect_distance then
					self._RingOfFlames_Table[id].been_alive = nil
				end
				local wpn_unit = self:local_player():inventory():equipped_unit()
				local hits = World:find_units("sphere", eff_pos, 200, managers.slot:get_mask("enemies"))
				for _, hit_unit in pairs(hits) do
					if managers.enemy:is_enemy(hit_unit) and not self._RingOfFlames_Hits[hit_unit:key()] then
						self._RingOfFlames_Hits[hit_unit:key()] = true
						hit_unit:character_damage():damage_fire({
							variant = "fire",
							damage = 10,
							weapon_unit = wpn_unit,
							attacker_unit = self:local_player(),
							col_ray = {ray = Vector3(1, 0, 0), hit_position = eff_pos, position = eff_pos},
							armor_piercing = true,
							fire_dot_data = {
								dot_trigger_chance = 100,
								dot_damage = 10,
								dot_length = 3.1,
								dot_trigger_max_distance = flame_effect_max_dis * 2,
								dot_tick_period = 0.5
							}
						})
					end
				end
			else
				self._RingOfFlames_Table[id].been_alive = nil
			end
			if not self._RingOfFlames_Table[id].been_alive then
				World:effect_manager():kill(effect_entry.id)
				table.remove(self._RingOfFlames_Table, id)
			end
		end
	end
end)