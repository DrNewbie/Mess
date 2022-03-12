local ThisModPath = ModPath
local Hook1 = "EEA_"..Idstring("sp_shockproof::has_category_upgrade::"..ThisModPath):key()

PlayerManager[Hook1] = PlayerManager[Hook1] or PlayerManager.has_category_upgrade

function PlayerManager:has_category_upgrade(category, upgrade, ...)
	if category == "player" and upgrade == "resist_firing_tased" and self:__EE_Armor_Has_Var(nil, 7) then
		return true
	end
	return self[Hook1](self, category, upgrade, ...)
end