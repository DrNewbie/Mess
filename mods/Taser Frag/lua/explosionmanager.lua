if Network:is_client() then
	return
end

function ExplosionManager:detect_and_give_dmg(params)
	local hit_pos = params.hit_pos
	local slotmask = params.collision_slotmask
	local user_unit = params.user
	local dmg = params.damage
	local player_dmg = params.player_damage or dmg
	local range = params.range
	local ignore_unit = params.ignore_unit
	local curve_pow = params.curve_pow
	local col_ray = params.col_ray
	local alert_filter = params.alert_filter or managers.groupai:state():get_unit_type_filter("civilians_enemies")
	local owner = params.owner
	local push_units = true
	local results = {}
	local alert_radius = params.alert_radius or 10000
	if params.push_units ~= nil then
		push_units = params.push_units
	end
	local player = managers.player:player_unit()
	
	if alive(player) and player_dmg ~= 0 then
		if not params._is_taser then
			player:character_damage():damage_explosion({
				position = hit_pos,
				range = range,
				damage = player_dmg,
				variant = "explosion",
				ignite_character = params.ignite_character
			})
		else
		
		end
	end
	local bodies = World:find_bodies("intersect", "sphere", hit_pos, range, slotmask)
	local alert_unit = user_unit
	if alive(alert_unit) and alert_unit:base() and alert_unit:base().thrower_unit then
		alert_unit = alert_unit:base():thrower_unit()
	end
	managers.groupai:state():propagate_alert({
		"explosion",
		hit_pos,
		alert_radius,
		alert_filter,
		alert_unit
	})
	local splinters = {
		mvector3.copy(hit_pos)
	}
	local dirs = {
		Vector3(range, 0, 0),
		Vector3(-range, 0, 0),
		Vector3(0, range, 0),
		Vector3(0, -range, 0),
		Vector3(0, 0, range),
		Vector3(0, 0, -range)
	}
	local pos = Vector3()
	for _, dir in ipairs(dirs) do
		mvector3.set(pos, dir)
		mvector3.add(pos, hit_pos)
		local splinter_ray
		if ignore_unit then
			splinter_ray = World:raycast("ray", hit_pos, pos, "ignore_unit", ignore_unit, "slot_mask", slotmask)
		else
			splinter_ray = World:raycast("ray", hit_pos, pos, "slot_mask", slotmask)
		end
		pos = (splinter_ray and splinter_ray.position or pos) - dir:normalized() * math.min(splinter_ray and splinter_ray.distance or 0, 10)
		local near_splinter = false
		for _, s_pos in ipairs(splinters) do
			if mvector3.distance_sq(pos, s_pos) < 900 then
				near_splinter = true
			else
			end
		end
		if not near_splinter then
			table.insert(splinters, mvector3.copy(pos))
		end
	end
	local count_cops = 0
	local count_gangsters = 0
	local count_civilians = 0
	local count_cop_kills = 0
	local count_gangster_kills = 0
	local count_civilian_kills = 0
	local characters_hit = {}
	local units_to_push = {}
	local hit_units = {}
	local ignore_units = {ignore_unit}
	local type
	if not params.no_raycast_check_characters then
		for _, hit_body in ipairs(bodies) do
			local character = hit_body:unit():character_damage() and hit_body:unit():character_damage().damage_explosion and not hit_body:unit():character_damage():dead()
			if character then
				table.insert(ignore_units, hit_body:unit())
			end
		end
	end
	for _, hit_body in ipairs(bodies) do
		local character = hit_body:unit():character_damage() and hit_body:unit():character_damage().damage_explosion and not hit_body:unit():character_damage():dead()
		local apply_dmg = hit_body:extension() and hit_body:extension().damage
		units_to_push[hit_body:unit():key()] = hit_body:unit()
		local dir, len, damage, ray_hit, damage_character
		if character and not characters_hit[hit_body:unit():key()] then
			if params.no_raycast_check_characters then
				ray_hit = true
				damage_character = true
				characters_hit[hit_body:unit():key()] = true
			else
				for i_splinter, s_pos in ipairs(splinters) do
					ray_hit = not World:raycast("ray", s_pos, hit_body:center_of_mass(), "slot_mask", slotmask - 17, "ignore_unit", ignore_units, "report")
					if ray_hit then
						characters_hit[hit_body:unit():key()] = true
						damage_character = true
					else
					end
				end
			end
			if ray_hit then
				local hit_unit = hit_body:unit()
				if hit_unit:base() and hit_unit:base()._tweak_table and not hit_unit:character_damage():dead() then
					type = hit_unit:base()._tweak_table
					if CopDamage.is_civilian(type) then
						count_civilians = count_civilians + 1
					elseif CopDamage.is_gangster(type) then
						count_gangsters = count_gangsters + 1
					elseif type == "russian" or type == "german" or type == "spanish" or type == "american" or type == "jowi" or type == "hoxton" then
					else
						count_cops = count_cops + 1
					end
				end
			end
		elseif apply_dmg or hit_body:dynamic() then
			ray_hit = true
		end
		if ray_hit then
			dir = hit_body:center_of_mass()
			len = mvector3.direction(dir, hit_pos, dir)
			damage = dmg * math.pow(math.clamp(1 - len / range, 0, 1), curve_pow)
			if apply_dmg then
				self:_apply_body_damage(true, hit_body, user_unit, dir, damage)
			end
			damage = math.max(damage, 1)
			local hit_unit = hit_body:unit()
			if ignore_unit ~= hit_unit then
				hit_units[hit_unit:key()] = hit_unit
				if character and damage_character then
					local dead_before = hit_unit:character_damage():dead()
					local action_data = {}
					action_data.variant = "explosion"
					action_data.damage = damage
					action_data.attacker_unit = user_unit
					action_data.weapon_unit = owner
					action_data.col_ray = self._col_ray or {
						position = hit_body:position(),
						ray = dir
					}
					action_data.ignite_character = params.ignite_character
					if not params._is_taser then
						hit_unit:character_damage():damage_explosion(action_data)
					else
						action_data.variant = "taser_tased"
						action_data.damage = 5
						action_data.damage_effect = 5
						action_data.name_id = "taser"
						action_data.charge_lerp_value = 0
						action_data.col_ray = {
							position = mvector3.copy(hit_unit:movement():m_head_pos()),
							body = hit_unit:body("body")
						}
						action_data.direction_vec = hit_unit:position() - action_data.attacker_unit:position():normalized()
						hit_unit:character_damage():damage_melee(action_data)
						hit_unit:movement():add_tased_effect(3)
					end
					if not dead_before and hit_unit:base() and hit_unit:base()._tweak_table and hit_unit:character_damage():dead() then
						type = hit_unit:base()._tweak_table
						if CopDamage.is_civilian(type) then
							count_civilian_kills = count_civilian_kills + 1
						elseif CopDamage.is_gangster(type) then
							count_gangster_kills = count_gangster_kills + 1
						elseif type == "russian" or type == "german" or type == "spanish" or type == "american" then
						else
							count_cop_kills = count_cop_kills + 1
						end
					end
				end
			end
		end
	end
	if push_units and push_units == true then
		managers.explosion:units_to_push(units_to_push, hit_pos, range)
	end
	if owner then
		results.count_cops = count_cops
		results.count_gangsters = count_gangsters
		results.count_civilians = count_civilians
		results.count_cop_kills = count_cop_kills
		results.count_gangster_kills = count_gangster_kills
		results.count_civilian_kills = count_civilian_kills
	end
	return hit_units, splinters, results
end