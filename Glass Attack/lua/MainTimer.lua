local GlassAttackTimer_Delay = 0

Hooks:Add("GameSetupUpdate", "GlassAttackTimer", function(t, dt)
	if not Utils:IsInHeist() or GlassAttackTimer_Delay > t then
		return
	end
	GlassAttackTimer_Delay = t + 3
	for _, data in pairs(managers.groupai:state():all_player_criminals()) do
		local _pos_z = tonumber(data.unit:position().z)
		if _pos_z < 2500 then
			local _peer = managers.network:session():peer_by_unit(data.unit)
			if _peer then
				if _peer:id() == 1 then
					local player = managers.player:local_player()
					managers.player:force_drop_carry()
					managers.statistics:downed({ death = true })
					IngameFatalState.on_local_player_dead()
					game_state_machine:change_state_by_name("ingame_waiting_for_respawn")
					player:character_damage():set_invulnerable(true)
					player:character_damage():set_health(0)
					player:base():_unregister()
					player:base():set_slot(player, 0)
				else
					data.unit:network():send("sync_player_movement_state", "incapacitated", 0, data.unit:id())
					data.unit:network():send_to_unit({"spawn_dropin_penalty", true, nil, 0, nil, nil })
					managers.groupai:state():on_player_criminal_death(_peer:id())
				end
			end
		end
	end
end)