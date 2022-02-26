local ThisModPath = ModPath
local Hook1 = "EEA_"..Idstring("sp_shockproof::has_category_upgrade::"..ThisModPath):key()

PlayerManager[Hook1] = PlayerManager[Hook1] or PlayerManager.has_category_upgrade

function PlayerManager:has_category_upgrade(category, upgrade, ...)
	if category == "player" and upgrade == "resist_firing_tased" then
		local sp_shockproof_now = managers.player:__EE_Armor_Get_Var_by_Lv_and_ID(nil, 7)
		if type(sp_shockproof_now) == "number" and sp_shockproof_now > 0 then
			return true
		end
	end
	return self[Hook1](self, category, upgrade, ...)
end