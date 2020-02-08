local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

Hooks:PostHook(HostNetworkSession, 'on_peer_sync_complete' , 'HostNetworkSessionOnPeerSyncComplete_KPR' , function(self, peer, peer_id)
	if managers.groupai then
		for _, unit in pairs(managers.groupai:state()._converted_police) do
			local owner_peer_id = unit:base().kpr_minion_owner_peer_id
			if owner_peer_id then
				local convert_enemies_health_multiplier_level = 0
				local passive_convert_enemies_health_multiplier_level = 0
				if owner_peer_id ~= 1 then
					local peer_unit = managers.network:session():peer(owner_peer_id):unit()
					if alive(peer_unit) then
						convert_enemies_health_multiplier_level = peer_unit:base():upgrade_level('player', 'convert_enemies_health_multiplier') or 0
						passive_convert_enemies_health_multiplier_level = peer_unit:base():upgrade_level('player', 'passive_convert_enemies_health_multiplier') or 0
					end
				else
					convert_enemies_health_multiplier_level = managers.player:upgrade_level('player', 'convert_enemies_health_multiplier')
					passive_convert_enemies_health_multiplier_level = managers.player:upgrade_level('player', 'passive_convert_enemies_health_multiplier')
				end
				managers.network:session():send_to_peer(peer, 'mark_minion', unit, owner_peer_id, convert_enemies_health_multiplier_level, passive_convert_enemies_health_multiplier_level)
			end
		end
	end
end)

Hooks:Add('BaseNetworkSessionOnPeerRemoved', 'BaseNetworkSessionOnPeerRemoved_Keepers', function(peer, peer_id, reason)
	Keepers.clients[peer_id] = false
end)
