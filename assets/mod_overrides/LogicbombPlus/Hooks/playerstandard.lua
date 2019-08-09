Hooks:PostHook(PlayerStandard, "_do_melee_damage", "logicbomb_melee_event", function(self, t, bayonet_melee, melee_hit_ray)
	local player_unit = managers.player:player_unit()
	local melee_id = managers.blackmarket:equipped_melee_weapon()
	if player_unit and melee_id and melee_id == "logicbomb" then
		local melee_tweak = tweak_data.blackmarket.melee_weapons[melee_id]
		local col_ray
		local sphere_cast_radius = 20
		local instant_hit = melee_tweak.instant
		local melee_damage_delay = melee_tweak.melee_damage_delay or 0
		local charge_lerp_value = instant_hit and 0 or self:_get_melee_charge_lerp_value(t, melee_damage_delay)
		if charge_lerp_value > 0.99 then
			if melee_hit_ray then
				col_ray = melee_hit_ray ~= true and melee_hit_ray or nil
			else
				col_ray = self:_calc_melee_hit_ray(t, sphere_cast_radius)
			end
			if col_ray then
				local pos_boom = nil
				if col_ray.hit_position then
					pos_boom = col_ray.hit_position
				elseif col_ray.position then
					pos_boom = col_ray.position
				elseif col_ray.unit and alive(col_ray.unit) and col_ray.unit:character_damage() then
					pos_boom = col_ray.unit:position()
				end
				if pos_boom then
					local ee_units = World:find_units("sphere", pos_boom, 10000, managers.slot:get_mask("enemies"))
					if ee_units then
						for _, u_unit in pairs(ee_units) do
							if u_unit and u_unit.contour and u_unit:contour() then
								u_unit:contour():add("mark_enemy_damage_bonus", true)
							end
						end
					end
				end
			end
		end
	end
end)