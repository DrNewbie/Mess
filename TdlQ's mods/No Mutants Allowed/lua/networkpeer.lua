local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local nma_original_networkpeer_onlost = NetworkPeer.on_lost
function NetworkPeer:on_lost()
	NoMA:UninitializePlayerProfile(self:id())
	nma_original_networkpeer_onlost(self)
end

local nma_original_networkpeer_verifygrenade = NetworkPeer.verify_grenade
function NetworkPeer:verify_grenade(value)
	if value == -1 then
		if self ~= managers.network:session():local_peer() then
			local profile = NoMA:GetPlayerProfile(self)
			if not profile.throwable.reusable and profile.previous_interaction_id ~= 'grenade_crate' then
				NoMA:CheckUpgrade(self, 'player_regain_throwable_from_ammo_1')
			end
		end
	end

	return nma_original_networkpeer_verifygrenade(self, value)
end
