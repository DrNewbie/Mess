_G.SilentTripMine = _G.SilentTripMine or {}

function TripMineBase.spawn(pos, rot, sensor_upgrade, peer_id)
	local _unit_name = "units/payday2/equipment/gen_equipment_tripmine/gen_equipment_tripmine"
	if SilentTripMine:Check_Is_Silent() then
		_unit_name = "units/payday2/equipment/gen_equipment_tripmine/gen_equipment_tripmine_silent"
	end
	local unit = World:spawn_unit(Idstring(_unit_name), pos, rot)
	managers.network:session():send_to_peers_synched("sync_trip_mine_setup", unit, sensor_upgrade, peer_id or 0)
	unit:base():setup(sensor_upgrade)
	return unit
end

function TripMineBase:get_name_id()
	return SilentTripMine:Check_Is_Silent() and "trip_mine_silent" or "trip_mine"
end

function TripMineBase:_explode(col_ray)
	if not managers.network:session() then
		return
	end
	local damage_size = tweak_data.weapon.trip_mines.damage_size * managers.player:upgrade_value("trip_mine", "explosion_size_multiplier_1", 1) * managers.player:upgrade_value("trip_mine", "damage_multiplier", 1)
	local player = managers.player:player_unit()
	managers.explosion:give_local_player_dmg(self._position, damage_size, tweak_data.weapon.trip_mines.player_damage)
	self._unit:set_extension_update_enabled(Idstring("base"), false)
	self._deactive_timer = 5
	self:_play_sound_and_effects()
	local slotmask = managers.slot:get_mask("explosion_targets")
	local bodies = World:find_bodies("intersect", "cylinder", self._ray_from_pos, self._ray_to_pos, damage_size, slotmask)
	local damage = tweak_data.weapon.trip_mines.damage * managers.player:upgrade_value("trip_mine", "damage_multiplier", 1)
	local characters_hit = {}
	for _, hit_body in ipairs(bodies) do
		if alive(hit_body) then
			local character = hit_body:unit():character_damage() and hit_body:unit():character_damage().damage_explosion
			local apply_dmg = hit_body:extension() and hit_body:extension().damage
			local dir, ray_hit
			if character and not characters_hit[hit_body:unit():key()] then
				local com = hit_body:center_of_mass()
				local ray_from = math.point_on_line(self._ray_from_pos, self._ray_to_pos, com)
				ray_hit = not World:raycast("ray", ray_from, com, "slot_mask", slotmask, "ignore_unit", {
					hit_body:unit()
				}, "report")
				if ray_hit then
					characters_hit[hit_body:unit():key()] = true
				end
			elseif apply_dmg or hit_body:dynamic() then
				ray_hit = true
			end
			if ray_hit then
				dir = hit_body:center_of_mass()
				mvector3.direction(dir, self._ray_from_pos, dir)
				if apply_dmg then
					local normal = dir
					local prop_damage = math.min(damage, 200)
					local network_damage = math.ceil(prop_damage * 163.84)
					prop_damage = network_damage / 163.84
					hit_body:extension().damage:damage_explosion(player, normal, hit_body:position(), dir, prop_damage)
					hit_body:extension().damage:damage_damage(player, normal, hit_body:position(), dir, prop_damage)
					if hit_body:unit():id() ~= -1 then
						if player then
							managers.network:session():send_to_peers_synched("sync_body_damage_explosion", hit_body, player, normal, hit_body:position(), dir, math.min(32768, network_damage))
						else
							managers.network:session():send_to_peers_synched("sync_body_damage_explosion_no_attacker", hit_body, normal, hit_body:position(), dir, math.min(32768, network_damage))
						end
					end
				end
				if hit_body:unit():in_slot(managers.game_play_central._slotmask_physics_push) then
					hit_body:unit():push(5, dir * 500)
				end
				if character then
					self:_give_explosion_damage(col_ray, hit_body:unit(), damage)
				end
			end
		end
	end
	if managers.network:session() then
		if managers.player:has_category_upgrade("trip_mine", "fire_trap") then
			local fire_trap_data = managers.player:upgrade_value("trip_mine", "fire_trap", nil)
			if fire_trap_data then
				managers.network:session():send_to_peers_synched("sync_trip_mine_explode_spawn_fire", self._unit, player, self._ray_from_pos, self._ray_to_pos, damage_size, damage, fire_trap_data[1], fire_trap_data[2])
				self:_spawn_environment_fire(player, fire_trap_data[1], fire_trap_data[2])
			end
		elseif player then
			managers.network:session():send_to_peers_synched("sync_trip_mine_explode", self._unit, player, self._ray_from_pos, self._ray_to_pos, damage_size, damage)
		else
			managers.network:session():send_to_peers_synched("sync_trip_mine_explode_no_user", self._unit, self._ray_from_pos, self._ray_to_pos, damage_size, damage)
		end
	end
	local alert_event = {
		"aggression",
		self._position,
		tweak_data.weapon.trip_mines.alert_radius,
		self._alert_filter,
		self._unit
	}
	if SilentTripMine:Check_Is_Silent() then
	
	else
		managers.groupai:state():propagate_alert(alert_event)
		if Network:is_server() then
			managers.mission:call_global_event("tripmine_exploded")
			Application:error("TRIPMINE EXPLODED")
		end
	end
	self._unit:set_slot(0)
end

function TripMineBase:_play_sound_and_effects()
	if SilentTripMine:Check_Is_Silent() then
		return
	end
	World:effect_manager():spawn({
		effect = Idstring("effects/particles/explosions/explosion_grenade"),
		position = self._unit:position(),
		normal = self._unit:rotation():y()
	})
	local sound_source = SoundDevice:create_source("TripMineBase")
	sound_source:set_position(self._unit:position())
	sound_source:post_event("trip_mine_explode")
	managers.enemy:add_delayed_clbk("TrMiexpl", callback(TripMineBase, TripMineBase, "_dispose_of_sound", {sound_source = sound_source}), TimerManager:game():time() + 4)
end