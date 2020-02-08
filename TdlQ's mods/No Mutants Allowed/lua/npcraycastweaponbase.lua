local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local _account_attack = function (target_unit)
end

DelayedCalls:Add('DelayedModNMA_sessionpeers', 1, function()
	local _peers = managers.network:session() and managers.network:session():peers() or {}
	local max_players = tweak_data.max_players
	local NoMA = NoMA
	_account_attack = function (target_unit)
		for peer_id = 1, max_players do
			local peer = _peers[peer_id]
			if peer and target_unit == peer._unit then
				local hacc = NoMA.hit_accounting[peer_id]
				if hacc then
					hacc.attacked_nr = hacc.attacked_nr + 1
				end
			end
		end
	end
end)

local nma_original_npcraycastweaponbase_triggerheld = NPCRaycastWeaponBase.trigger_held
function NPCRaycastWeaponBase:trigger_held(...)
	local fired = nma_original_npcraycastweaponbase_triggerheld(self, ...)
	if fired then
		_account_attack(select(8, ...))
	end
	return fired
end

local nma_original_npcraycastweaponbase_singleshot = NPCRaycastWeaponBase.singleshot
function NPCRaycastWeaponBase:singleshot(...)
	local fired = nma_original_npcraycastweaponbase_singleshot(self, ...)
	if fired then
		_account_attack(select(8, ...))
	end
	return fired
end
