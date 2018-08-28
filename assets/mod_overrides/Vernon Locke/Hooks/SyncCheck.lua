function FakeAddOnCharaSyncFix(peer, d1, d2, d3, d4, d5, d6, d7, d8, d9, ...)
	local _d1 = tostring(d1)
	if _d1 == "sync_outfit" then
		local list = managers.blackmarket:unpack_outfit_from_string(d2)
		local chara = tostring(list.character)
		log("sync_outfit: "..chara)
		if not tweak_data.blackmarket.characters[chara] or tweak_data.blackmarket.characters[chara].custom then
			list.character = "locked"
			d2 = BeardLib.Utils:OutfitStringFromList(list)
			log("d2: "..d2)
		end
	elseif _d1 == "lobby_info" then
		local chara = tostring(d4)
		if not tweak_data.blackmarket.characters[chara] or tweak_data.blackmarket.characters[chara].custom then
			d4 = "bodhi"
		end
	elseif _d1 == "join_request_reply" then
		local chara = tostring(d9)
		if not tweak_data.blackmarket.characters[chara] or tweak_data.blackmarket.characters[chara].custom then
			d9 = "bodhi"
		end
	end
	return d1, d2, d3, d4, d5, d6, d7, d8, d9, ...
end

local AddOnCharaSync_Net_send = NetworkPeer.send
function NetworkPeer:send(...)
	return AddOnCharaSync_Net_send(self, FakeAddOnCharaSyncFix(self, ...))
end

local AddOnCharaSync_Net_send_queued_sync = NetworkPeer.send_queued_sync
function NetworkPeer:send_queued_sync(...)
	return AddOnCharaSync_Net_send_queued_sync(self, FakeAddOnCharaSyncFix(self, ...))
end