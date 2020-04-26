Hooks:PreHook(AmmoClip, "_pickup", "F_"..Idstring("PreHook:AmmoClip:_pickup:Gambler Perk Deck Buff"):key(), function(self, category, upgrade)
	if not self._picked_up and not self.__bonnie_share_twice and self._ammo_box and managers.network and managers.network:session() and managers.network:session():local_peer() then
		local player = managers.player:local_player()
		local player_manager = managers.player
		if not player_manager or not alive(player) or not player:character_damage() or player:character_damage():is_downed() or player:character_damage():dead() or not player_manager:has_category_upgrade("player", "loose_ammo_give_team_twice") then
		
		else
			local inventory = player:inventory()
			local __is_okay
			for _, weapon in pairs(inventory:available_selections()) do
				if not self._weapon_category or self._weapon_category == weapon.unit:base():weapon_tweak_data().categories[1] then
					if type(weapon) == "table" and weapon.unit and not weapon.unit:base():ammo_full() then
						__is_okay = true
						break
					end
				end
			end
			if __is_okay then
				self.__bonnie_share_twice = true
				if player_manager:has_category_upgrade("temporary", "loose_ammo_give_team") then
					managers.network:session():send_to_peers_synched_except(managers.network:session():local_peer():id(), "sync_unit_event_id_16", self._unit, "pickup", AmmoClip.EVENT_IDS.bonnie_share_ammo)
				end
				if player_manager:has_category_upgrade("player", "loose_ammo_restore_health_give_team") then
					managers.network:session():send_to_peers_synched_except(managers.network:session():local_peer():id(), "sync_unit_event_id_16", self._unit, "pickup", 2 + 13)
				end
				log(1)
			end
		end
	end
end)