if Network:is_client() then
	return
end

_G.SurvivorModeBase = _G.SurvivorModeBase or {}

SurvivorModeBase.Version = "beta.5"
SurvivorModeBase.Sync_Check = {}

function SurvivorModeBase:Sync_Send(Sync_asked, data, peer_id)
	_Net = _G and _G.LuaNetworking or nil
	if _Net then
		if not peer_id then
			_Net:SendToPeers(Sync_asked, data)
		else
			_Net:SendToPeer(peer_id, Sync_asked, data)
		end
	else
		log("[SurvivorModeBase]: Sync_Send Fail. '".. Sync_asked .."'")
	end
end

Hooks:Add("NetworkReceivedData", "NetworkReceivedData_SurvivorMode", function(sender, sync_asked, data)
	_Net = _G and _G.LuaNetworking or nil
	if sync_asked and data and _Net then
		if sync_asked == "SurvivorMode_Sync_Check_Ans" then
			data = tonumber(data)
			sender = tonumber(sender)
			if sender > 1 then
				sender = sender - 1
				SurvivorModeBase.Sync_Check[sender] = data
			end
		end
	end
	for k, v in pairs(SurvivorModeBase.Sync_Check) do
		local _name = _Net:GetNameFromPeerID( k+1 )
		if _name then
			if v == 2 then
				managers.chat:feed_system_message(1, "'".. _name .."' is running same version")
			elseif v == 1 then
				managers.chat:feed_system_message(1, "'".. _name .."' is running different version")
			else
				managers.chat:feed_system_message(1, "'".. _name .."' no respond, did he install [Client Side] yet?")
			end
		end
	end
end)