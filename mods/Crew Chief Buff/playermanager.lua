local mod_ids = Idstring("Crew Chief Buff"):key()
local func10 = "F_"..Idstring("func10::"..mod_ids):key()

PlayerManager[func10] = PlayerManager[func10] or PlayerManager.upgrade_value

function PlayerManager:upgrade_value(c1, c2, ...)
	local __ans = self[func10](self, c1, c2, ...)
	if self:has_category_upgrade("player", "ccb_intimidate_range_mul") then
		if c1 == "player" and c2 == "civ_intimidation_mul" then
			__ans = __ans + 0.25
		elseif c1 == "player" and c2 == "passive_intimidate_range_mul" then
			__ans = __ans + 0.25
		elseif c1 == "player" and c2 == "intimidate_aura" then
			__ans = __ans * 1.25
		end
	end
	return __ans
end