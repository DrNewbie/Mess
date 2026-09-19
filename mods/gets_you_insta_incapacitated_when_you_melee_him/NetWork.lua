Hooks:PostHook(UnitNetworkHandler, "damage_melee", "F_"..Idstring("gets you insta incapacitated when you melee him.UnitNetworkHandler.damage_melee"):key(), function(self, subject_unit, attacker_unit, damage, damage_effect, i_body, height_offset, variant, death, sender)
	if not managers.network:session() or not managers.network:session():is_host() then
	
	else
		if not self._verify_character_and_sender(subject_unit, sender) or not self._verify_gamestate(self._gamestate_filter.any_ingame) then
		
		else
			if not alive(attacker_unit) or attacker_unit:key() == subject_unit:key() then
			
			else
				if managers.enemy:is_enemy(subject_unit) and alive(subject_unit) and tostring(subject_unit:base()._tweak_table):find("tank") then
					local session = managers.network:session()
					if session then
						local peer = sender:protocol_at_index(0) == "STEAM" and session:peer_by_user_id(sender:ip_at_index(0)) or session:peer_by_ip(sender:ip_at_index(0))
						if peer then
							attacker_unit:network():send("sync_player_movement_state", "incapacitated", 60, attacker_unit:id())
						end
					end
				end
			end
		end
	end
end)