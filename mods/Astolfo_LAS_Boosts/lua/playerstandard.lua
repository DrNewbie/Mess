Hooks:PostHook(PlayerStandard, "init", "F_"..Idstring("PlayerStandard:init:AstolfoLASBoosts"):key(), function(self)
	if managers.player:Is_LAS_Grandcutie() then
		self._hit_soundsource = SoundDevice:create_source("vehicle_hit")
	end
end)

Hooks:PostHook(PlayerStandard, "_update_movement", "F_"..Idstring("PlayerStandard:_update_movement:AstolfoLASBoosts"):key(), function(self, t)
	if self._unit and alive(self._unit) and self:running() and self._unit.oobb and managers.player:Is_LAS_Grandcutie() then
		local oobb = self._unit:oobb()
		if oobb then
			local slotmask = managers.slot:get_mask("flesh")
			local units = World:find_units("intersect", "obb", oobb:center(), oobb:x(), oobb:y(), oobb:z(), slotmask)
			local dir_hit = self._ext_movement:m_head_rot():y()
			mvector3.set_z(dir_hit, math.abs(dir_hit.z)*2*math.random())
			for _, unit in pairs(units) do
				if unit:in_slot(managers.slot:get_mask("all_criminals")) then
				
				elseif unit:in_slot(managers.slot:get_mask("civilians")) then
				
				elseif unit:character_damage() and not unit:character_damage():dead() then
					unit:base()._get_succ_t = unit:base()._get_succ_t or 0
					if t > unit:base()._get_succ_t then
						self._ext_movement:_change_stamina(-(self._ext_movement:_max_stamina()*2))
						unit:base()._get_succ_t = t + 1
						self._hit_soundsource:set_position(unit:position())
						self._hit_soundsource:set_rtpc("car_hit_vel", 100)
						self._hit_soundsource:post_event("car_hit_body_01")
						local damage_ext = unit:character_damage()
						if damage_ext and damage_ext.damage_mission then
							damage_ext:damage_mission({
								variant = "explosion",
								damage = 1,
								attacker_unit = self._unit
							})
							call_on_next_update(function ()
								managers.game_play_central:do_shotgun_push(unit, unit:position() + Vector3(math.rand(1), math.rand(1), math.rand(1)), dir_hit * math.random(), math.random(1, 50), self._unit)
							end)
						end
					end
				end
			end
		end
	end
end)

local p_load = "packages/load_car_sound"
if PackageManager:package_exists(p_load) then
	if PackageManager:loaded(p_load) then
		PackageManager:unload(p_load)
	end
	PackageManager:load(p_load)
end