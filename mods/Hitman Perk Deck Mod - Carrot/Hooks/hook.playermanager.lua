local ThisModPath = ModPath
local ThisModIds = Idstring(ThisModPath):key()
local old_upgrade_value = PlayerManager.upgrade_value

function PlayerManager:upgrade_value(__category, __upgrade, ...)
	local __ans = old_upgrade_value(self, __category, __upgrade, ...)
	if __category == "player" and __upgrade == "pick_up_ammo_multiplier" and self:has_category_upgrade("player", "addition_ammo_pickup_hitman_mod") then
		__ans = __ans + self:upgrade_value("player", "addition_ammo_pickup_hitman_mod", 0)
	elseif __category == "player" and __upgrade == "extra_ammo_multiplier" and self:has_category_upgrade("player", "addition_more_ammo_hitman_mod") then
		__ans = __ans + self:upgrade_value("player", "addition_more_ammo_hitman_mod", 0)
	end
	return __ans
end