_G.WeaponKicker = _G.WeaponKicker or {}

Hooks:PreHook(HuskPlayerInventory, "synch_equipped_weapon", "WeaponKicker_Check", function(self, weap_index)
	if not weap_index then
		return
	end
	local weapon_name = self._get_weapon_name_from_sync_index(weap_index)
	if not weapon_name then
		return
	end
	weapon_name = tostring(weapon_name)
	if not weapon_name:find('_npc') then
		return
	end
	weapon_name = weapon_name:gsub('_npc', '')
	local _name = managers.weapon_factory:get_weapon_name_by_factory_id(weapon_name)
	local _id = managers.weapon_factory:get_weapon_id_by_factory_id(weapon_name)
	if _id and _name and WeaponKicker and WeaponKicker.Settings and WeaponKicker.Settings[_id] then
		local peer = managers.network:session():peer_by_unit(self._unit)
		if peer then
			local identifier = "cheater_banned_" .. tostring(peer:id())
			managers.ban_list:ban(identifier, peer:name())
			managers.chat:feed_system_message(1, peer:name() .. " has been kicked because of using a weapons that match the blacklist: " .. _name)
			local message_id = 6
			managers.network:session():send_to_peers("kick_peer", peer:id(), message_id)
			managers.network:session():on_peer_kicked(peer, peer:id(), message_id)
			return
		end
	end
end)