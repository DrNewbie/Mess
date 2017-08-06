if Network:is_client() then
	return
end

_G.NoSenseGate = _G.NoSenseGate or {}

if not NoSenseGate then
	return
end

function NoSenseGate:Sync_Send(Sync_asked, data, peer_id)
	_Net = _G and _G.LuaNetworking or nil
	if _Net then
		if not peer_id then
			_Net:SendToPeers(Sync_asked, data)
		else
			_Net:SendToPeer(peer_id, Sync_asked, data)
		end
	else
		log("[NoSenseGate]: Sync_Send Fail. '".. Sync_asked .."'")
	end
end