local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local nma_original_basenetworksession_onpeerremoved = BaseNetworkSession._on_peer_removed
function BaseNetworkSession:_on_peer_removed(peer, peer_id, reason)
	nma_original_basenetworksession_onpeerremoved(self, peer, peer_id, reason)
	NoMA:UninitializePlayerProfile(peer_id)
end

local nma_original_basenetworksession_spawnplayers = BaseNetworkSession.spawn_players
function BaseNetworkSession:spawn_players(...)
	NoMA.spawn_t = TimerManager:game():time()
	return nma_original_basenetworksession_spawnplayers(self, ...)
end

DelayedCalls:Add('DelayedModNoMA_connectionnetworkhandler', 0, function()
	local nma_original_connectionnetworkhandler_syncoutfit = ConnectionNetworkHandler.sync_outfit
	function ConnectionNetworkHandler:sync_outfit(outfit_string, outfit_version, outfit_signature, sender)
		nma_original_connectionnetworkhandler_syncoutfit(self, outfit_string, outfit_version, outfit_signature, sender)

		if not game_state_machine:verify_game_state(GameStateFilters.lobby) then
			local peer = self._verify_sender(sender)
			if peer and NoMA then
				NoMA:CheckOutfit(peer, outfit_string)
			end
		end
	end

	local nma_original_connectionnetworkhandler_preplanningreserved = ConnectionNetworkHandler.preplanning_reserved
	function ConnectionNetworkHandler:preplanning_reserved(type, id, peer_id, state, sender)
		if not self._verify_sender(sender) then
			return
		end

		nma_original_connectionnetworkhandler_preplanningreserved(self, type, id, peer_id, state, sender)

		local asset = tweak_data.preplanning.types[type]
		if asset and asset.upgrade_lock then
			NoMA:CheckUpgrade(managers.network:session():peer(peer_id), asset.upgrade_lock.category .. '_' .. asset.upgrade_lock.upgrade)
		end
	end

	local nma_original_connectionnetworkhandler_reservepreplanning = ConnectionNetworkHandler.reserve_preplanning
	function ConnectionNetworkHandler:reserve_preplanning(type, id, state, sender)
		local peer = self._verify_sender(sender)
		if not peer then
			return
		end

		nma_original_connectionnetworkhandler_reservepreplanning(self, type, id, state, sender)

		local asset = tweak_data.preplanning.types[type]
		if asset and asset.upgrade_lock then
			NoMA:CheckUpgrade(peer, asset.upgrade_lock.category .. '_' .. asset.upgrade_lock.upgrade)
		end
	end
end)
