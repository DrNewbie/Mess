local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local fs_original_huskplayermovement_syncstartautofiresound = HuskPlayerMovement.sync_start_auto_fire_sound
function HuskPlayerMovement:sync_start_auto_fire_sound(...)
	if alive(self._unit:inventory():equipped_unit()) then
		fs_original_huskplayermovement_syncstartautofiresound(self, ...)
	end
end

-- Removal of crappy mods users
local fs_original_huskplayermovement_animclbkspawndroppedmagazine = HuskPlayerMovement.anim_clbk_spawn_dropped_magazine
function HuskPlayerMovement:anim_clbk_spawn_dropped_magazine()
	if not self._magazine_data then
		local equipped_weapon = self._unit:inventory():equipped_unit()
		if alive(equipped_weapon) then
			local weapon_base = equipped_weapon:base()
			if weapon_base and weapon_base._assembly_complete then
				local td = tweak_data.weapon[weapon_base._name_id]
				if td and td.pull_magazine_during_reload then
					local has_mag
					for part_id, part_data in pairs(equipped_weapon:base()._parts) do
						local part = tweak_data.weapon.factory.parts[part_id]
						if part and part.type == 'magazine' then
							has_mag = true
							break
						end
					end
					if not has_mag then
						if Network:is_server() then
							local session = managers.network:session()
							local peer = session:peer_by_unit(self._unit)
							if peer then
								managers.chat:_receive_message(ChatManager.GAME, 'FSS', 'crash avoided and culprit banned', tweak_data.system_chat_color)
								managers.ban_list:ban(peer:user_id(), peer:name())
								session:send_to_peers('kick_peer', peer:id(), 6)
								session:on_peer_kicked(peer, peer:id(), 6)
							end
						end
						return
					end
				end
			end
		end
	end

	fs_original_huskplayermovement_animclbkspawndroppedmagazine(self)
end
