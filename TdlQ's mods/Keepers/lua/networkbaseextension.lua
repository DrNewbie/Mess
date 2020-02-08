local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

function NetworkBaseExtension:kpr_send(func, ...)
	local session = managers.network:session()
	if session then
		local clients = Keepers.clients
		for peer_id, peer in pairs(session:peers()) do
			if peer_id ~= 1 and clients[peer_id] then
				session:send_to_peer_synched(peer, func, self._unit, ...)
			end
		end
	end
end
