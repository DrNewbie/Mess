local ThisModPath = ModPath
local ThisModIds = Idstring(ThisModPath):key()
local __Name = function(__id)
	return "FS_"..Idstring(tostring(__id).."::"..ThisModIds):key()
end

local func1 = __Name("func1::")
local func2 = __Name("func2::")
local hook1 = __Name("hook1::")
local hook2 = __Name("hook2::")

Hooks:PostHook(PlayerDamage, "update", hook1, function(self, unit, t, dt)
	if self._unit and self._unit.base and self._unit:base() then
		self[func1] = self[func1] or {}
		self[func2] = self[func2] or {}
		if self[func2][self._unit:key()] and self[func2][self._unit:key()] > t then
		
		else
			self[func2] = {}
			self[func2][self._unit:key()] = t + 12
		end
		local z_fix = Vector3(0, 0, 110)
		local speed_v = 100
		if not self[func1].__unit then
			self[func1].__unit = true
			self[func1].__unit = safe_spawn_unit(Idstring("units/payday2/characters/ene_acc_shield_small/shield_small"), self._unit:position() + z_fix, self._unit:rotation())
			local __objects = {
				"g_shield",
				"rp_ene_acc_shield_small",
				"c_box_left_middle",
				"c_box_left_bottom",
				"c_box_right",
				"c_box_left_top",
				"c_sphere_bottom"
			}
			for _, __object in pairs(__objects) do
				if self[func1].__unit:get_object(Idstring(__object))  then
					World:effect_manager():spawn({
						effect = Idstring("effects/particles/fire/small_light_fire"),
						parent = self[func1].__unit:get_object(Idstring(__object))
					})
				end
			end
		end
		if self[func1].__unit then
			local t_var = ( t*speed_v )%360
			local new_pos = self._unit:position() + z_fix + Vector3(math.cos(t_var)*100, math.sin(t_var)*100, 0)
			self[func1].__unit:set_position(new_pos)
			self[func1].__unit:set_rotation(Rotation(t_var + 180 + 90, 0, 0))
			self[func1].__unit:set_enabled(false)
			self[func1].__unit:set_enabled(true)
			local __units = World:find_units("sphere", new_pos, 75,  managers.slot:get_mask("enemies", "civilians"))
			if type(__units) == "table" then
				for _, __hit in pairs(__units) do
					if __hit:character_damage() and not __hit:character_damage():dead() and __hit:character_damage().damage_fire then
						if self[func2][__hit:key()] and self[func2][__hit:key()] > t then
						
						else
							self[func2][__hit:key()] = t + 3
							__hit:character_damage():damage_fire({
								variant = "fire",
								damage = 1,
								attacker_unit = self._unit,
								col_ray = {
									position = __hit:position(),
									ray = math.UP
								},
								armor_piercing = true,
								fire_dot_data = {
									dot_trigger_chance = 100,
									dot_damage = 10,
									dot_length = 8.1,
									dot_trigger_max_distance = 3000,
									dot_tick_period = 0.5
								}
							})
						end
					end
				end
			end
		end
	end
end)

Hooks:PreHook(PlayerDamage, "pre_destroy", hook2, function(self)
	if self._unit and type(self[func1]) == "table" then
		self[func1] = self[func1] or {}
		for i, d in pairs(self[func1]) do
			if self[func1].__unit then
				self[func1].__unit:set_slot(0)
				self[func1].__unit = nil
			end
		end
	end
end)