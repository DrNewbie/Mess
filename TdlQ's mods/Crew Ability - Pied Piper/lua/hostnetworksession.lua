local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local has_ability_pied_piper
local phench = type(Global) == 'table' and type(Global.blackmarket_manager) == 'table' and Global.blackmarket_manager._selected_henchmen
if type(phench) == 'table' then
	for _, v in pairs(phench) do
		if type(v) == 'table' and v.ability == 'crew_pied_piper' then
			has_ability_pied_piper = true
			break
		end
	end
end
if not has_ability_pied_piper then
	return
end

local capp_original_hostnetworksession_sendtopeerssynched = HostNetworkSession.send_to_peers_synched
function HostNetworkSession:send_to_peers_synched(typ, ...)
	if typ == 'set_unit' then
		local params = {...}
		local loadout = params[3]
		if loadout:find('crew_pied_piper') then
			local patched_loadout = loadout:gsub('crew_pied_piper', 'nil')
			for peer_id, peer in pairs(self._peers) do
				params[3] = CrewAbilityPiedPiper:peer_has_capp(peer) and loadout or patched_loadout
				peer:send_queued_sync(typ, unpack(params))
			end
			return
		end
	end

	capp_original_hostnetworksession_sendtopeerssynched(self, typ, ...)
end

local capp_original_hostnetworksession_chkdropinpeer = HostNetworkSession.chk_drop_in_peer
function HostNetworkSession:chk_drop_in_peer(dropin_peer)
	if dropin_peer:expecting_dropin() and not CrewAbilityPiedPiper:peer_has_capp(dropin_peer) then
		CrewAbilityPiedPiper.filter_ability = true
	end

	local result = capp_original_hostnetworksession_chkdropinpeer(self, dropin_peer)

	CrewAbilityPiedPiper.filter_ability = false

	return result
end
