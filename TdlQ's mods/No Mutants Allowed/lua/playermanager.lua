local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

dofile(ModPath .. 'lua/_nomutantsallowed.lua')

local nma_original_playermanager_addsyncedteamupgrade = PlayerManager.add_synced_team_upgrade
function PlayerManager:add_synced_team_upgrade(peer_id, category, upgrade, level)
	nma_original_playermanager_addsyncedteamupgrade(self, peer_id, category, upgrade, level)
	NoMA:CheckUpgrade(managers.network:session():peer(peer_id), nil, category, upgrade, level)
end
