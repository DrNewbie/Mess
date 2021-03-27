local ThisModPath = ModPath

_G.GuardianBonusBuff = _G.GuardianBonusBuff or {}

GuardianBonusBuff_upgrade_value = GuardianBonusBuff_upgrade_value or PlayerManager.upgrade_value

function PlayerManager:upgrade_value(category, upgrade, ...)
	local Ans = GuardianBonusBuff_upgrade_value(self, category, upgrade, ...)
	if GuardianBonusBuff and GuardianBonusBuff.GetBonusPercent then
		if category == "player" and upgrade == "health_multiplier" then
			Ans = Ans + (GuardianBonusBuff:GetBonusPercent("increase_maximum_health")/100)
		elseif category == "player" and upgrade == "armor_multiplier" then
			Ans = Ans + (GuardianBonusBuff:GetBonusPercent("increase_maximum_armor")/100)
		elseif category == "player" and upgrade == "critical_hit_chance" then
			Ans = Ans + (GuardianBonusBuff:GetBonusPercent("increase_addon_critical")/100)
		elseif category == "player" and upgrade == "passive_dodge_chance" then
			Ans = Ans + (GuardianBonusBuff:GetBonusPercent("increase_addon_dodge")/100)
		elseif category == "weapon" and upgrade == "passive_swap_speed_multiplier" then
			Ans = Ans + (GuardianBonusBuff:GetBonusPercent("increase_addon_weapon_switch_speed")/100)
		end
	end
	return Ans
end