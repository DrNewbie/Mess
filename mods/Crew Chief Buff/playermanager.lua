--[[local mod_ids = Idstring("Crew Chief Buff"):key()
local func1 = "F_"..Idstring("func1::"..mod_ids):key()

PlayerManager[func1] = PlayerManager[func1] or PlayerManager.get_hostage_bonus_multiplier

function PlayerManager:get_hostage_bonus_multiplier(category, ...)
	local __ans = self[func1](self, category, ...)
	local hostages = managers.groupai and managers.groupai:state():hostage_count() or 0
	local minions = self:num_local_minions() or 0
	local multiplier = 0
	hostages = hostages + minions
	local hostage_max_num = tweak_data:get_raw_value("upgrades", "hostage_max_num", category)
	if hostage_max_num then
		hostages = math.min(hostages, hostage_max_num)
	end
	multiplier = multiplier + self:team_upgrade_value(category, "hostage_multiplier", 1) - 1
	multiplier = multiplier + self:team_upgrade_value(category, "passive_hostage_multiplier", 1) - 1
	multiplier = multiplier + self:upgrade_value("player", "hostage_" .. category .. "_multiplier", 1) - 1
	multiplier = multiplier + self:upgrade_value("player", "passive_hostage_" .. category .. "_multiplier", 1) - 1
	if self:has_category_upgrade("player", "close_to_hostage_boost") and self._is_local_close_to_hostage then
		multiplier = multiplier * tweak_data.upgrades.hostage_near_player_multiplier
	end
	return 1 + multiplier * hostages * 2
end]]