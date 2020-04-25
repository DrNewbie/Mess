local ThisModPath = ModPath

_G.GuardianBonusBuff = _G.GuardianBonusBuff or {}

GuardianBonusBuff_upgrade_value = GuardianBonusBuff_upgrade_value or PlayerManager.upgrade_value

function PlayerManager:upgrade_value(category, upgrade, ...)
	local Ans = GuardianBonusBuff_upgrade_value(self, category, upgrade, ...)
	if GuardianBonusBuff and GuardianBonusBuff.GetBonusPercent then
		if category == "player" and upgrade == "health_multiplier" then
			Ans = Ans + (GuardianBonusBuff:GetBonusPercent("increase_maximum_health")/100)
		end
		if category == "player" and upgrade == "armor_multiplier" then
			Ans = Ans + (GuardianBonusBuff:GetBonusPercent("increase_maximum_armor")/100)
		end
	end
	return Ans
end