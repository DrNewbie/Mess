local ThisModPath = ModPath
local ThisModIds = Idstring(ThisModPath):key()

local old_movement_speed_multiplier = PlayerManager.movement_speed_multiplier

function PlayerManager:movement_speed_multiplier(...)
	local __ans = old_movement_speed_multiplier(self, ...)
	if self:has_category_upgrade("player", "yakuza_mod_movement_speed_multiplier_1") then
		__ans = __ans * (1 + self:upgrade_value("player", "yakuza_mod_movement_speed_multiplier_1", 0))
	end
	return __ans
end

local old_body_armor_regen_multiplier = PlayerManager.body_armor_regen_multiplier

function PlayerManager:body_armor_regen_multiplier(moving, health_ratio, ...)
	local __ans = old_body_armor_regen_multiplier(self, moving, health_ratio, ...)
	if self:has_category_upgrade("player", "yakuza_mod_armor_regen_multiplier_1") then
		__ans = __ans * (1 + self:upgrade_value("player", "yakuza_mod_armor_regen_multiplier_1", 0))
	end
	if health_ratio and self:has_category_upgrade("player", "yakuza_mod_armor_regen_health_ratio_multiplier_1") then
		local damage_health_ratio = self:get_damage_health_ratio(health_ratio, "movement_speed")
		__ans = __ans * (1 + self:upgrade_value("player", "yakuza_mod_armor_regen_health_ratio_multiplier_1", 0)*damage_health_ratio)
	end
	return __ans
end

local old_skill_dodge_chance = PlayerManager.skill_dodge_chance

function PlayerManager:skill_dodge_chance(...)
	local __ans = old_skill_dodge_chance(self, ...)
	if self:player_unit() and self:has_category_upgrade("player", "yakuza_mod_dodge_health_ratio_multiplier_1") then
		local health_ratio = self:player_unit():character_damage():health_ratio()
		local damage_health_ratio = self:get_damage_health_ratio(health_ratio, "movement_speed")
		__ans = __ans + self:upgrade_value("player", "yakuza_mod_dodge_health_ratio_multiplier_1", 0)*damage_health_ratio
	end
	return __ans
end