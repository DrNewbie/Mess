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
			
			if not choose_unit or not choose_unit:movement() or not choose_unit:brain() then

			else
				local logic = tostring(choose_unit:brain()._current_logic_name)
				
				if logic == "travel" or logic == "assault" or logic == "idle" or logic == "attack" then
					choose_unit:movement():play_redirect("throw_grenade")
					
					local projectile_type = "concussion"
					local from_pos = choose_unit:movement():m_head_pos()
					local mvec_spread_direction = choose_unit:movement():m_fwd() + Vector3(0, 0, math.random())
					
					if Global.game_settings.single_player or (managers.network:session() and Network:is_server()) then
						local all_player_criminals = managers.groupai:state():all_player_criminals()
						local cc_unit = ProjectileBase.spawn("units/pd2_crimefest_2016/fez1/weapons/wpn_fps_gre_pressure/wpn_third_gre_pressure", from_pos, Rotation())
						cc_unit:base():throw({
							dir = mvec_spread_direction,
							owner = managers.player:local_player() or throw_owner_unit
						})
					else
						--local projectile_type_index = tweak_data.blackmarket:get_index_from_projectile_id(projectile_type)
						--managers.network:session():send_to_host("request_throw_projectile", projectile_type_index, from_pos, mvec_spread_direction)
					end				
				end
			end
		end
	end
end)