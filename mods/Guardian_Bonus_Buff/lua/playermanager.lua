local ThisModPath = ModPath
local ThisModIds = Idstring(ThisModPath):key()

local __Name = function(__id)
	return "GGG_"..Idstring(tostring(__id).."::"..ThisModIds):key()
end

_G.GuardianBonusBuff = _G.GuardianBonusBuff or {}

if _G.GuardianBonusBuff[__Name(98)] then return end

_G.GuardianBonusBuff[__Name(98)] = true

local Name1 = __Name(1)
local Name3 = __Name(3)

DelayedCalls:Add(__Name(2), 1, function()
	pcall(
		function ()
			PlayerManager[Name1] = PlayerManager[Name1] or PlayerManager.upgrade_value
			function PlayerManager:upgrade_value(category, upgrade, ...)
				local Ans = self[Name1](self, category, upgrade, ...)
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
					elseif category == "player" and upgrade == "movement_speed_multiplier" then
						Ans = Ans + GuardianBonusBuff:GetBonusPercent("increase_movement_speed_multiplier")
					end
				end
				return Ans
			end
			
			PlayerManager[Name3] = PlayerManager[Name3] or PlayerManager.damage_reduction_skill_multiplier
			function PlayerManager:damage_reduction_skill_multiplier(...)
				local Ans = self[Name3](self, ...)
				local GBB_DRC = GuardianBonusBuff:GetBonusPercent("increase_damage_reduction_multiplier")
				Ans = Ans - GBB_DRC
				return math.max(Ans, 0)
			end
		end
	)
end)