Hooks:PostHook(GroupAIStateBase, "update", "JokerThrowLoopEvent", function(self, t, dt)
	if not self:whisper_mode() then
		if self._joker_throw_event_dt then
			self._joker_throw_event_dt = self._joker_throw_event_dt - dt
			if self._joker_throw_event_dt <= 0 then
				self._joker_throw_event_dt = nil
			end
		else
			self._joker_throw_event_dt = math.random(20, 50)
			
			if type(self:all_player_criminals()) ~= "table" then
				return
			end
			
			local player_units = {}
			
			for u_key, u_data in pairs(self:all_player_criminals() or {}) do
				if u_data.unit and alive(u_data.unit) then
					table.insert(player_units, u_data.unit)
				end
			end
			
			local throw_owner_unit = table.random(player_units)
			
			local possible_units = {}		
			for u_key, u_data in pairs(self:all_AI_criminals() or {}) do
				if u_data.unit then
					table.insert(possible_units, u_data.unit)
				end
			end	
			for u_key, u_unit in pairs(self:all_converted_enemies() or {}) do
				if u_unit and alive(u_unit) and u_unit:character_damage() and u_unit:character_damage().dead and not u_unit:character_damage():dead() then
					table.insert(possible_units, u_unit)
				end
			end
			
			local choose_unit = table.random(possible_units)
			
			if not choose_unit or not alive(choose_unit) or not choose_unit:movement() or not choose_unit:brain() then
				self._joker_throw_event_dt = 1
			else
				local logic = tostring(choose_unit:brain()._current_logic_name)
				
				if logic == "travel" or logic == "assault" or logic == "idle" or logic == "attack" then
					local from_pos = choose_unit:movement():m_head_pos()
					local mvec_spread_direction = choose_unit:movement():m_fwd()
					local to_pos = Vector3()
					mvector3.set(to_pos, mvec_spread_direction)
					mvector3.multiply(to_pos, 800)
					mvector3.add(to_pos, from_pos)
					mvector3.set_z(to_pos, from_pos.z)
					
					local hits = World:raycast_all("ray", from_pos, to_pos, "sphere_cast_radius", 800, "disable_inner_ray", "slot_mask", managers.slot:get_mask("enemies"))

					local is_ok_throw = false
					if hits then
						local enemies_count = 0
						for _, hit in pairs(hits) do
							if hit.unit and alive(hit.unit) and managers.enemy:is_enemy(hit.unit) and not self:is_enemy_converted_to_criminal(hit.unit) then
								enemies_count = enemies_count + 1
								mvec_spread_direction = hit.unit:position() - choose_unit:position()
							end
						end
						if enemies_count > 3 then
							is_ok_throw = true
						end
					end
					
					if not is_ok_throw then
						self._joker_throw_event_dt = 1
						return
					end
					
					choose_unit:movement():play_redirect("throw_grenade")
					
					if Global.game_settings.single_player or (managers.network:session() and Network:is_server()) then
						local all_player_criminals = managers.groupai:state():all_player_criminals()
						local cc_unit = ProjectileBase.spawn("units/pd2_crimefest_2016/fez1/weapons/wpn_fps_gre_pressure/wpn_third_gre_pressure", from_pos, Rotation())
						if cc_unit then
							mvector3.normalize(mvec_spread_direction)
							cc_unit:base():throw({
								dir = mvec_spread_direction,
								owner = managers.player:local_player() or throw_owner_unit
							})
						end
					end				
				end
			end
		end
	end
end)