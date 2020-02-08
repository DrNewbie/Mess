local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local nma_original_ammoclip_syncnetevent = AmmoClip.sync_net_event
function AmmoClip:sync_net_event(event, peer)
	nma_original_ammoclip_syncnetevent(self, event, peer)

	if event == AmmoClip.EVENT_IDS.bonnie_share_ammo then
		NoMA:CheckUpgrade(peer, 'temporary_loose_ammo_give_team')
	elseif event == AmmoClip.EVENT_IDS.register_grenade then
		-- Nothing
	elseif event > AmmoClip.EVENT_IDS.bonnie_share_ammo then
		NoMA:CheckUpgrade(peer, 'player_loose_ammo_restore_health_give_team')
	end
end
