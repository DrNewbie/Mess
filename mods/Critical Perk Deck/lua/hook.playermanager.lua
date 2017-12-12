function PlayerManager:addon_critical_hit_chance()
	local addon = self:upgrade_value("player", "passive_additional_surprise_1", 0)
	addon = addon + self:upgrade_value("player", "passive_additional_surprise_2", 0)
	return addon
end

local CriticalPerk_critical_hit_chance = PlayerManager.critical_hit_chance

function PlayerManager:critical_hit_chance()
	local addon = self:addon_critical_hit_chance()
	if addon > 0 and math.random() < addon then
		local player = self:player_unit()
		if player then
			local damage_ex = player:character_damage()
			if damage_ex and not damage_ex:arrested() and not damage_ex:need_revive() and damage_ex:get_real_armor() <= 0 then
				local regen_rate = managers.player:upgrade_value("player", "passive_critical_gain_health_1", 0)
				regen_rate = regen_rate + managers.player:upgrade_value("player", "passive_critical_gain_health_2", 0)
				if regen_rate > 0 then
					damage_ex:restore_health(regen_rate, true)
				end
			end
		end
		return 100
	end
	return CriticalPerk_critical_hit_chance(self)
end

local CriticalPerk_upgrade_value = PlayerManager.upgrade_value

function PlayerManager:upgrade_value(category, upgrade, default)
	local Ans = CriticalPerk_upgrade_value(self, category, upgrade, default)
	if upgrade == "reload_speed_multiplier" then
		Ans = Ans + self:upgrade_value("weapon", "passive_ct_reload_speed_multiplier_1", 0)
		Ans = Ans + self:upgrade_value("weapon", "passive_ct_reload_speed_multiplier_2", 0)
	end
	return Ans
end