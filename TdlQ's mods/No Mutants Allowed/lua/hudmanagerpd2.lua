local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local nma_original_hudmanager_addteammatepanel = HUDManager.add_teammate_panel
function HUDManager:add_teammate_panel(character_name, player_name, ai, peer_id)
	if peer_id then
		NoMA.hit_accounting[peer_id] = {
			attacked_nr = 0,
			armor_hit_nr = 0,
			health_hit_nr = 0,
			last_armor = 100,
			last_health = 100
		}
	end
	return nma_original_hudmanager_addteammatepanel(self, character_name, player_name, ai, peer_id)
end

local nma_original_hudmanager_setteammatehealth = HUDManager.set_teammate_health
function HUDManager:set_teammate_health(i, data)
	local panel = self._teammate_panels[i]
	if not panel._ai then
		local peer_id = panel:peer_id()
		local hacc = NoMA.hit_accounting[peer_id]
		if hacc then
			if data.current < hacc.last_health then
				hacc.health_hit_nr = hacc.health_hit_nr + 1
			end
			hacc.last_health = data.current
		end
	end

	return nma_original_hudmanager_setteammatehealth(self, i, data)
end

local nma_original_hudmanager_setteammatearmor = HUDManager.set_teammate_armor
function HUDManager:set_teammate_armor(i, data)
	local panel = self._teammate_panels[i]
	if not panel._ai then
		local peer_id = panel:peer_id()
		local hacc = NoMA.hit_accounting[peer_id]
		if hacc then
			if data.current < hacc.last_armor then
				hacc.armor_hit_nr = hacc.armor_hit_nr + 1
			end
			hacc.last_armor = data.current
		end
	end

	return nma_original_hudmanager_setteammatearmor(self, i, data)
end
