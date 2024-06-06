local ThisModPath = ModPath
local ThisModPathIds = Idstring(ThisModPath):key()

_G.GuardianBonusBuff = _G.GuardianBonusBuff or {}

PlayerManager[ThisModPathIds] = PlayerManager[ThisModPathIds] or PlayerManager.upgrade_value

function PlayerManager:upgrade_value(category, upgrade, ...)
	local Ans = self[ThisModPathIds](self, category, upgrade, ...)
	if GuardianBonusBuff and GuardianBonusBuff.GetBonusPercent then
		if category == "player" and upgrade == "health_multiplier" then
			Ans = Ans + GuardianBonusBuff:GetBonusPercent("increase_maximum_health")
		elseif category == "player" and upgrade == "armor_multiplier" then
			Ans = Ans + GuardianBonusBuff:GetBonusPercent("increase_maximum_armor")
		elseif category == "player" and upgrade == "critical_hit_chance" then
			Ans = Ans + GuardianBonusBuff:GetBonusPercent("increase_addon_critical")
		elseif category == "player" and upgrade == "passive_dodge_chance" then
			Ans = Ans + GuardianBonusBuff:GetBonusPercent("increase_addon_dodge")
		elseif category == "weapon" and upgrade == "passive_swap_speed_multiplier" then
			Ans = Ans + GuardianBonusBuff:GetBonusPercent("increase_addon_weapon_switch_speed")
		elseif category == "player" and upgrade == "pick_up_ammo_multiplier" then
			Ans = Ans + GuardianBonusBuff:GetBonusPercent("increase_addon_pick_up_ammo_multiplier")
		elseif category == "player" and upgrade == "armor_regen_time_mul" then
			Ans = Ans - GuardianBonusBuff:GetBonusPercent("increase_addon_armor_regen_time_mul")
			Ans = math.max(Ans, 0.001)
		elseif category == "player" and upgrade == "crouch_speed_multiplier" then
			Ans = Ans + GuardianBonusBuff:GetBonusPercent("increase_crouch_speed_multiplier")
		elseif category == "player" and upgrade == "stamina_multiplier" then
			Ans = Ans + GuardianBonusBuff:GetBonusPercent("increase_stamina_multiplier")
		elseif category == "player" and upgrade == "extra_ammo_multiplier" then
			Ans = Ans + GuardianBonusBuff:GetBonusPercent("increase_extra_ammo_multiplier")
		end
	end
	return Ans
end