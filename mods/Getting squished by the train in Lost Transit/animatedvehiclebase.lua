LocomotiveHurtBase = LocomotiveHurtBase or class(UnitBase)

function LocomotiveHurtBase:init(unit)
	UnitBase.init(self, unit, true)
	self._unit = unit
	self._last_pos = self._unit:position()
	self._touch_slot = managers.slot:get_mask("all")
	self._touch_dis_sq = 25 * 25
end

function LocomotiveHurtBase:update(unit, t, dt)
	if self._last_pos and self._unit:position().z < self._last_pos.z then
		self._last_pos = self._unit:position()
		local all_criminals = managers.groupai:state():all_criminals()
		for u_key, u_data in pairs(all_criminals) do
			if alive(u_data.unit) and type(u_data.unit.character_damage) == "function" and u_data.unit:character_damage() and type(u_data.unit.movement) == "function" and u_data.unit:movement() then
				local check_this_unit = u_data.unit
				local c_head_pos = check_this_unit:movement():m_head_pos()
				if c_head_pos then
					local col_rayy = World:raycast("ray", c_head_pos, c_head_pos + Vector3(0, 0, 999999), "slot_mask", managers.slot:get_mask("all"))
					if col_rayy and col_rayy.unit == self._unit and mvector3.distance_sq(col_rayy.hit_position, c_head_pos) <= self._touch_dis_sq then
						local peer = managers.network:session():peer_by_unit(check_this_unit)
						if peer then
							if peer:id() == 1 then
								managers.player:force_drop_carry()
								managers.statistics:downed({death = true})
								IngameFatalState.on_local_player_dead()
								game_state_machine:change_state_by_name("ingame_waiting_for_respawn")
								check_this_unit:character_damage():set_invulnerable(true)
								check_this_unit:character_damage():set_health(0)
								check_this_unit:base():_unregister()
								check_this_unit:base():set_slot(check_this_unit, 0)
							else
								check_this_unit:network():send("sync_player_movement_state", "incapacitated", 0, check_this_unit:id())
								check_this_unit:network():send_to_unit({"spawn_dropin_penalty", true, nil, 0, nil, nil})
								managers.groupai:state():on_player_criminal_death(check_this_unit:network():peer():id())
								end
						else
							if check_this_unit:character_damage().force_custody then
								check_this_unit:character_damage():force_custody()
							end
						end
					end
				end
			end
		end
	end
end