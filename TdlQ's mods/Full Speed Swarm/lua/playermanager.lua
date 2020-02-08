local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local fs_original_playermanager_init = PlayerManager.init
function PlayerManager:init()
	fs_original_playermanager_init(self)
	self:fs_reset_max_health()
end

function PlayerManager:fs_reset_max_health()
	self.fs_current_max_health = (PlayerDamage._HEALTH_INIT + self:health_skill_addend()) * self:health_skill_multiplier()
end

if not _G.IS_VR then
	local fs_original_playermanager_exitvehicle = PlayerManager.exit_vehicle
	function PlayerManager:exit_vehicle()
		fs_original_playermanager_exitvehicle(self)
		managers.interaction.reset_ordered_list()
	end
end

function PlayerManager:fs_max_movement_speed_multiplier()
	local multiplier = 1
	local armor_penalty = self:mod_movement_penalty(self:body_armor_value('movement', false, 1)) -- TODO: consider armor kit *yawn*
	multiplier = multiplier + (armor_penalty - 1)
	multiplier = multiplier + (self:upgrade_value('player', 'run_speed_multiplier', 1) - 1)
	multiplier = multiplier + (self:upgrade_value('player', 'movement_speed_multiplier', 1) - 1)

	if self:has_category_upgrade('player', 'minion_master_speed_multiplier') then
		multiplier = multiplier + (self:upgrade_value('player', 'minion_master_speed_multiplier', 1) - 1)
	end

	local damage_health_ratio = self:get_damage_health_ratio(0.01, 'movement_speed')
	multiplier = multiplier * (1 + self:upgrade_value('player', 'movement_speed_damage_health_ratio_multiplier', 0) * damage_health_ratio)

	if self:has_category_upgrade('temporary', 'damage_speed_multiplier') then
		local damage_speed_multiplier = self:upgrade_value('temporary', 'damage_speed_multiplier', self:upgrade_value('temporary', 'team_damage_speed_multiplier_received', 1))
		multiplier = multiplier * ((damage_speed_multiplier[1] - 1) * 0.5 + 1)
	end

	return multiplier
end

function PlayerManager:has_category_upgrade(category, upgrade)
	local upgs_ctg = self._global.upgrades[category]
	if upgs_ctg and upgs_ctg[upgrade] then
		return true
	end
	return false
end

local tweak_upg_values = tweak_data.upgrades.values
function PlayerManager:upgrade_value(category, upgrade, default)
	local upgs_ctg = self._global.upgrades[category]
	if not upgs_ctg then
		return default or 0
	end
	local level = upgs_ctg[upgrade]
	if not level then
		return default or 0
	end
	local value = tweak_upg_values[category][upgrade][level]
	return value or value ~= false and (default or 0) or false
end

local cached_hostage_bonus_multiplier = {}
function PlayerManager:reset_cached_hostage_bonus_multiplier()
	cached_hostage_bonus_multiplier = {}
end

local fs_original_playermanager_gethostagebonusmultiplier = PlayerManager.get_hostage_bonus_multiplier
function PlayerManager:get_hostage_bonus_multiplier(category)
	local key = category .. tostring(self._is_local_close_to_hostage)
	local result = cached_hostage_bonus_multiplier[key]
	if not result then
		result = fs_original_playermanager_gethostagebonusmultiplier(self, category)
		cached_hostage_bonus_multiplier[key] = result
	end
	return result
end

local cached_armor = {}
function PlayerManager:body_armor_value(category, override_value, default)
	if override_value then
		return self:upgrade_value_by_level('player', 'body_armor', category, {})[override_value] or default or 0
	else
		local result = cached_armor[category]
		if not result then
			local armor_id, cacheable = managers.blackmarket:equipped_armor(true, true)
			local armor_data = tweak_data.blackmarket.armors[armor_id]
			result = self:upgrade_value_by_level('player', 'body_armor', category, {})[armor_data.upgrade_level] or default or 0
			if cacheable then
				cached_armor[category] = result
			end
		end
		return result
	end
end

function PlayerManager:get_hostage_bonus_addend(category)
	local groupai = managers.groupai
	local hostages = groupai and groupai:state():hostage_count() or 0
	local minions = self:num_local_minions() or 0
	local addend = 0
	hostages = hostages + minions

	if hostages == 0 then
		return 0
	end

	local hostage_max_num = tweak_data:get_raw_value('upgrades', 'hostage_max_num', category)
	if hostage_max_num then
		hostages = math.min(hostages, hostage_max_num)
	end
	addend = addend + self:team_upgrade_value(category, 'hostage_addend', 0)
	addend = addend + self:team_upgrade_value(category, 'passive_hostage_addend', 0)
	addend = addend + self:upgrade_value('player', 'hostage_' .. category .. '_addend', 0)
	addend = addend + self:upgrade_value('player', 'passive_hostage_' .. category .. '_addend', 0)
	local local_player = self:local_player()
	if self:has_category_upgrade('player', 'close_to_hostage_boost') and self._is_local_close_to_hostage then
		addend = addend * tweak_data.upgrades.hostage_near_player_multiplier
	end
	return addend * hostages
end

function PlayerManager:body_armor_skill_addend(override_armor)
	local addend = 0
	addend = addend + self:upgrade_value('player', tostring(override_armor or managers.blackmarket:equipped_armor(true, true)) .. '_armor_addend', 0)
	addend = addend + self.fs_current_max_health * self:upgrade_value('player', 'armor_increase', 0)
	addend = addend + self:upgrade_value('team', 'crew_add_armor', 0)
	return addend
end

function PlayerManager:fs_body_armor_skill_multiplier(override_armor)
	local multiplier = self.fs_bas_multiplier
	multiplier = multiplier + self:team_upgrade_value('armor', 'multiplier', 1)
	multiplier = multiplier + self:get_hostage_bonus_multiplier('armor')
	multiplier = multiplier + self:upgrade_value('player', tostring(override_armor or managers.blackmarket:equipped_armor(true, true)) .. '_armor_multiplier', 1)
	multiplier = multiplier + self:upgrade_value('player', 'chico_armor_multiplier', 1)
	return multiplier - 4
end

function PlayerManager:fs_refresh_body_armor_skill_multiplier()
	local multiplier = 1
	multiplier = multiplier + self:upgrade_value('player', 'tier_armor_multiplier', 1)
	multiplier = multiplier + self:upgrade_value('player', 'passive_armor_multiplier', 1)
	multiplier = multiplier + self:upgrade_value('player', 'armor_multiplier', 1)
	multiplier = multiplier + self:upgrade_value('player', 'perk_armor_loss_multiplier', 1)
	self.fs_bas_multiplier = multiplier - 4
end

function PlayerManager:body_armor_skill_multiplier(override_armor)
	local multiplier = 1
	multiplier = multiplier + self:upgrade_value('player', 'tier_armor_multiplier', 1)
	multiplier = multiplier + self:upgrade_value('player', 'passive_armor_multiplier', 1)
	multiplier = multiplier + self:upgrade_value('player', 'armor_multiplier', 1)
	multiplier = multiplier + self:upgrade_value('player', 'perk_armor_loss_multiplier', 1)

	self.fs_bas_multiplier = multiplier - 4
	self.body_armor_skill_multiplier = self.fs_body_armor_skill_multiplier

	multiplier = multiplier + self:team_upgrade_value('armor', 'multiplier', 1)
	multiplier = multiplier + self:get_hostage_bonus_multiplier('armor')
	multiplier = multiplier + self:upgrade_value('player', tostring(override_armor or managers.blackmarket:equipped_armor(true, true)) .. '_armor_multiplier', 1)
	multiplier = multiplier + self:upgrade_value('player', 'chico_armor_multiplier', 1)

	return multiplier - 8
end

local fs_original_playermanager_synccarrydata = PlayerManager.sync_carry_data
function PlayerManager:sync_carry_data(unit, ...)
	unit:set_extension_update_enabled(Idstring('carry_data'), true)
	fs_original_playermanager_synccarrydata(self, unit, ...)
end
