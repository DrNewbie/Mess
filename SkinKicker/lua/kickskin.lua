function kickskin_func(peer)
	if managers.network and managers.network:session() then
		local outfit, tweak
		if peer:has_blackmarket_outfit() then
			outfit = peer:blackmarket_outfit()
			for _, weapon in ipairs({"primary", "secondary"}) do
				if outfit[weapon] and outfit[weapon].cosmetics then
					tweak = tweak_data.blackmarket.weapon_skins[outfit[weapon].cosmetics.id]
					if tweak then
						managers.chat:_receive_message(1, "[Skin Kicker]", "" .. peer:name() .. " is using skin.", Color.green) 
						managers.network:session():send_to_peers("kick_peer", peer:id(), 2)
						managers.network:session():on_peer_kicked(peer, peer:id(), 2)
						return
					end
				end
			end
		end
	end
	return
end

function isHost()
	if not Network then return false end
	return not Network:is_client()
end

local _hudname = HUDManager.set_teammate_name
function HUDManager:set_teammate_name(i, teammate_name)
	_hudname(self, i, teammate_name)
	local peer_userss = managers.network:session():peer(i)
	if peer_userss and isHost() then
		kickskin_func(peer_userss)
	end
end