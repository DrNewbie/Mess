_G.NoMA = _G.NoMA or {}
NoMA.spawn_t = 0
NoMA.timespeedchange_t = 0
NoMA.profiles = {} -- indexed on peer:id()
NoMA.profiles_persistent_data = {} -- indexed on peer:user_id()
NoMA.hit_accounting = {}
NoMA.min_skill_pt_to_unlock_tier = {
	{ 0, 1, 3, 18 },
	{ 0, 1, 3, 16 }
}

local function logf(...)
	log(string.format(...))
end

function NoMA:MakeStatsTable()
	return {
		assessed_nr = 0,
		not_assessed_nr = 0,
		armor_pierced_nr = 0,
		damage_all_counter = {},
		eval_counter = { 0, 0, 0, 0 },
		damage_eval_counter = { {}, {}, {}, {} },
		bonus_eval_counter = { total = 0 }
	}
end

function NoMA:InitializePlayerProfile(peer)
	logf('[NoMA] %s (%s) initializing profile in slot %s',
		tostring(peer:name()), tostring(peer:skills()), tostring(peer:id()))

	local user_id = peer:user_id()
	self.profiles_persistent_data[user_id] = self.profiles_persistent_data[user_id] or {
		timers_total = 0,
		timers_short = 0,
		network_prbs = 0,
		timers_sum = 0,
		timers_real_sum = 0
	}

	local profile = {
		outfit_string = '',
		name = tostring(peer:name()),
		skills = tostring(peer:skills()),
		upgrades = {},
		pts_per_tree = {},
		arbo = {},
		interaction_timers = {},
		persistent = self.profiles_persistent_data[user_id],
		perk_id = 0,
		perk_rank = 0,
		previous_packet_loss = 0,
		previous_health_pct = 100,
		previous_armor_pct = 100,
		time_tased = 0,
		inspire_t = -1000,
		start_t = 0,
		pitch_changes_nr = 0,
		fired_bullets_nr = 0,
		difficulty = Global.game_settings and Global.game_settings.difficulty,
	}
	profile.weapons = { {}, {} }
	profile.weapons[1] = self:MakeStatsTable()
	profile.weapons[1].ammo_checked = false
	profile.weapons[2] = self:MakeStatsTable()
	profile.throwable = self:MakeStatsTable()
	profile.melee = self:MakeStatsTable()
	profile.melee.bloodthirst_mul_tracker = 1
	profile.melee.start_t = 0
	profile.melee.discharge_t = 0

	for tree_id, tree in ipairs(tweak_data.skilltree.trees) do
		profile.arbo[tree_id] = {{}}
		for tier_id in ipairs(tree.tiers) do
			profile.arbo[tree_id][tier_id + 1] = {}
		end
	end

	if peer == managers.network:session():local_peer() then
		profile.infamous = managers.experience:current_rank() == 0 and 1 or 2
		profile.level = managers.experience:current_level()
	elseif peer:level() ~= nil then
		profile.infamous = peer:rank() == 0 and 1 or 2
		profile.level = peer:level()
	elseif peer._profile.level ~= nil then
		profile.infamous = peer._profile.rank == 0 and 1 or 2
		profile.level = peer._profile.level
	else
		logf('[NoMA] %s (SteamID %s) player information not received yet, profile creation cancelled',
			profile.name, user_id)
		self.profiles[peer:id()] = nil
		return
	end

	self.profiles[peer:id()] = profile

	local peer_skills = profile.skills
	local peer_skills_split = peer_skills and peer_skills:split('-')
	if peer_skills_split then
		local sum = 0
		for tree, v in ipairs((peer_skills_split[1] or ''):split('_')) do
			profile.pts_per_tree[tree] = tonumber(v)
			sum = sum + tonumber(v)
		end
		logf('[NoMA] %s (%s) is using %i skill points (max. is %i for level %i)',
			profile.name, profile.skills, sum, self:SkillPointsOfLevel(profile.level), profile.level)

		local perk = (peer_skills_split[2] or ''):split('_')
		if perk then
			profile.perk_id = tonumber(perk[1])
			profile.perk_rank = tonumber(perk[2])
			if profile.perk_id > #tweak_data.skilltree.specializations then
				logf('[NoMA] %s (%s) unknown perk deck! (%i)',
					profile.name, profile.skills, profile.perk_id)
				self:MarkCheater(peer, 'fake perk deck')
			end
		end
	end

	if not self:IsProfileOK(profile) then
		logf('[NoMA] %s (%s) profile overflow! %s',
			profile.name, profile.skills, json.encode(profile.pts_per_tree))
		self:MarkCheater(peer)
	end

	return profile
end

function NoMA:GetPlayerProfile(peer)
	if not peer then
		return
	end

	local profile = self.profiles[peer:id()] or self:InitializePlayerProfile(peer)
	if profile then
		profile.net_latency = peer:qos().ping
	end
	return profile
end

function NoMA:GetPlayerProfileByUnit(unit)
	if not unit then
		return
	end
	local peer = managers.network:session():peer_by_unit(unit)
	if not peer then
		return
	end
	return self:GetPlayerProfile(peer), peer
end

function NoMA:UninitializePlayerProfile(peer_id)
	log('[NoMA] Uninitializing profile ' .. tostring(peer_id))
	local profile = self.profiles[peer_id]

	self.profiles[peer_id] = nil

	local peer = managers.network:session():peer(peer_id)
	if peer then
		peer._cheater = false
	end
end

function NoMA:GetSkillPointsOfTree(tree, min_skill_pt_to_unlock_tier)
	local sum_pts = 0
	for tier, skills in ipairs(tree) do
		if #skills > 0 then
			sum_pts = math.max(sum_pts, min_skill_pt_to_unlock_tier[tier])
			for _, pts in ipairs(skills) do
				sum_pts = sum_pts + pts
			end
		end
	end
	return sum_pts
end

function NoMA:UpdatePlayerUpgrades(profile, upgrade_name)
	if not profile.upgrades[upgrade_name] then
		profile.upgrades[upgrade_name] = 1
		return true
	end
end

function NoMA:UpdatePlayerSkillUpgrades(profile, req)
	if self:UpdatePlayerUpgrades(profile, req.upgrade_name) then
		local tier_cost = tweak_data.skilltree.tier_cost[req.tier]
		local cost = tier_cost[1] + (req.pos == 2 and tier_cost[2] or 0)
		profile.arbo[req.tree_id][req.tier][req.pos] = math.max(cost, profile.arbo[req.tree_id][req.tier][req.pos] or 0)
		return true
	end
end

function NoMA:SkillPointsOfLevel(level)
	return tonumber(level) + 2 * math.floor(tonumber(level) / 10)
end

function NoMA:IsProfileOK(profile)
	if profile.outfit_string ~= '' and #profile.pts_per_tree ~= #tweak_data.skilltree.trees then
		return false
	end

	local sum = 0
	for _, v in ipairs(profile.pts_per_tree) do
		sum = sum + v
	end
	local spl = self:SkillPointsOfLevel(profile.level)
	if sum > spl then
		return false
	end

	for tree_id, v in ipairs(profile.pts_per_tree) do
		if v < self:GetSkillPointsOfTree(profile.arbo[tree_id], self.min_skill_pt_to_unlock_tier[profile.infamous]) then
			logf('[NoMA] %s (%s) anomaly on tree %i', profile.name, profile.skills, tree_id)
			return false
		end
	end

	return true
end

function NoMA:IsDefaultUpgrade(upgrade_name)
	for _, v in pairs(tweak_data.skilltree.default_upgrades) do
		if upgrade_name == v then
			return true
		end
	end

	return false
end

function NoMA:GetWeaponId(factory_id)
	for _, def in pairs(tweak_data.upgrades.definitions) do
		if def.factory_id == factory_id and def.category == 'weapon' then
			return def.weapon_id
		end
	end
	log('[NoMA] GetWeaponName() choked on ' .. tostring(factory_id))
end

function NoMA:GetUpgradeRequirements(profile, upgrade_names)
	local reqs = {}

	-- perks
	for perk_id, perk in pairs(tweak_data.skilltree.specializations) do
		for rank, data in pairs(perk) do
			for _, perk_upgrade in ipairs(data.upgrades or {}) do
				if upgrade_names[perk_upgrade] then
					table.insert(reqs, {
						type = 'p',
						perk_id = perk_id,
						min_rank = rank,
						upgrade_name = perk_upgrade
					})
					break
				end
			end
		end
	end

	-- skills
	local cnt = 0
	local skills = tweak_data.skilltree.skills
	for tree_id, tree in ipairs(tweak_data.skilltree.trees) do -- tweak_data.skilltree.skills has unusable stuff
		for tier_id, tier in ipairs(tree.tiers) do
			for skill_pos, skill_name in ipairs(tier) do
				local skill = skills[skill_name]
				local cost = 0
				local tier_cost = tweak_data.skilltree.tier_cost[tier_id]
				for skill_level = 1, 2 do
					cost = cost + tier_cost[skill_level]
					for _, upgrade in ipairs(skill[skill_level].upgrades or {}) do
						if upgrade_names[upgrade] then
							cnt = cnt + 1
							table.insert(reqs, {
								type = 's',
								tree_id = tree_id,
								tier = tier_id,
								pos = skill_pos,
								skill = skill_name,
								level = skill_level,
								min_skill_pt = self.min_skill_pt_to_unlock_tier[profile.infamous][tier_id] + cost,
								upgrade_name = upgrade
							})
							break
						end
					end
				end
			end
		end
	end

	return cnt == 1, reqs
end

function NoMA:IsLegitimateUpgrade(profile, upgrade_names)
	local accountable, reqs = self:GetUpgradeRequirements(profile, upgrade_names)
	if #reqs == 0 then
		return true
	end

	local is_ok = false
	for _, req in ipairs(reqs) do
		if req.type == 'p' then
			if profile.perk_id == req.perk_id and profile.perk_rank >= req.min_rank then
				self:UpdatePlayerUpgrades(profile, req.upgrade_name)
				is_ok = true
				break
			end
		elseif req.type == 's' then
			if accountable then
				if self:UpdatePlayerSkillUpgrades(profile, req) then
					if not self:IsProfileOK(profile) then
						break
					end
				end
			end
			local tree_pts = profile.pts_per_tree[req.tree_id]
			if tree_pts and tree_pts >= req.min_skill_pt then
				is_ok = true
				break
			end
		else
			logf("[NoMA] unknown requirement type '%s'", tostring(req.type))
		end
	end

	return is_ok
end

function NoMA:GetCheaterMessage(peer, reason)
	if reason then
		reason = ': ' .. reason .. '.'
	else
		reason = '.'
	end

	return peer:name() .. ' is cheating' .. reason
end

function NoMA:Tell(msg)
	managers.chat:_receive_message(ChatManager.GAME, 'NoMA', msg, tweak_data.system_chat_color)
end

function NoMA:LogProfile(peer_id)
	local profile = self.profiles[peer_id]

	local fwb1 = profile.weapons[1].fake_base
	local fwb2 = profile.weapons[2].fake_base

	profile.weapons[1].fake_base = nil
	profile.weapons[2].fake_base = nil

	logf('[NoMA] profiles[%i] = %s', peer_id, json.encode(profile))

	profile.weapons[1].fake_base = fwb1
	profile.weapons[2].fake_base = fwb2
end

function NoMA:MarkCheater(peer, reason)
	if peer:is_cheater() then
		return
	end

	if managers.crime_spree and managers.crime_spree._unlocked_assets then
		return
	end

	self:Tell(self:GetCheaterMessage(peer, reason))

	peer._cheater = true
	if managers.hud then
		managers.hud:mark_cheater(peer:id())
	end

	self:LogProfile(peer:id())

	return true
end

function NoMA:GetUpgradeDefinitionNames(profile, upgrade_name)
	local result
	if profile.upgrades[upgrade_name] then
		-- qued
	elseif self:IsDefaultUpgrade(upgrade_name) then
		profile.upgrades[upgrade_name] = 1
	else
		result = { [upgrade_name] = 1 }
	end
	return result
end

function NoMA:GetUpgradeDefinitionNamesEx(profile, category, name, level)
	local result
	local value = tonumber(level)

	for k, def in pairs(tweak_data.upgrades.definitions) do
		local upgrade = def.upgrade
		if upgrade and upgrade.upgrade == name and upgrade.category == category and upgrade.value == value then
			if self:IsDefaultUpgrade(k) then
				profile.upgrades[k] = 1
				return
			end
			result = result or {}
			result[k] = 1
		end
	end

	return result
end

function NoMA:CheckUpgrade(peer, upgrade_name, category, name, level)
	local profile = self:GetPlayerProfile(peer)
	if not profile then
		return
	end

	local definition_name = upgrade_name or string.format('%s/%s/%s', category, name, level)
	if profile.upgrades[definition_name] then
		return
	end

	local upgrade_names
	if upgrade_name then
		upgrade_names = self:GetUpgradeDefinitionNames(profile, upgrade_name)
	else
		upgrade_names = self:GetUpgradeDefinitionNamesEx(profile, category, name, level)
	end
	if not upgrade_names then
		logf('[NoMA] %s (%s) skipping %s', profile.name, profile.skills, definition_name)
		return
	end

	local result
	local is_ok = self:IsLegitimateUpgrade(profile, upgrade_names)
	if is_ok then
		result = 'OK'
		profile.upgrades[definition_name] = 1
	else
		result = 'NOK'
		self:MarkCheater(peer, 'lacking skill for ' .. definition_name)
	end
	logf('[NoMA] %s (%s) check %s %s', profile.name, profile.skills, result, definition_name)
end

function NoMA:MakeFakeWeaponBase(factory_id, blueprint, name_id)
	local original_shotgunbase_setupdefault
	local cls = 'NewRaycastWeaponBase'
	local categories = tweak_data.weapon[name_id].categories
	if categories then
		if table.contains(categories, 'shotgun') then
			cls = 'ShotgunBase'
			original_shotgunbase_setupdefault = ShotgunBase.setup_default
			function ShotgunBase:setup_default()
				self._ammo_data = self._ammo_data or managers.weapon_factory:get_ammo_data_from_weapon(factory_id, blueprint) or {}
				original_shotgunbase_setupdefault(self)
			end
		elseif table.contains(categories, 'flamethrower') then
			cls = 'NewFlamethrowerBase'
		elseif table.contains(categories, 'grenade_launcher') then
			cls = 'ProjectileWeaponBase'
		elseif table.contains(categories, 'bow') then
			cls = 'BowWeaponBase'
		elseif table.contains(categories, 'crossbow') then
			cls = 'CrossbowWeaponBase'
		elseif table.contains(categories, 'akimbo') then
			cls = 'AkimboWeaponBase'
		elseif table.contains(categories, 'saw') then
			cls = 'SawWeaponBase'
		end
		if not _G[cls] then
			cls = 'NewRaycastWeaponBase'
		end
	end

	local fake_unit = {
		get_object = function() end,
		set_extension_update_enabled = function() end,
		orientation_object = function() end,
	}

	local original_SoundDevice = SoundDevice
	SoundDevice = {
		create_source = function()
			return {
				link = function() end,
				post_event = function() end,
				set_switch = function() end,
			}
		end,
		stop = function() end
	}

	local result = class(_G[cls]):new(fake_unit)

	SoundDevice = original_SoundDevice
	if original_shotgunbase_setupdefault then
		ShotgunBase.setup_default = original_shotgunbase_setupdefault
	end

	result._blueprint = blueprint
	result._factory_id = factory_id
	result._name_id = name_id
	result._ammo_pickup = tweak_data.weapon[name_id].AMMO_PICKUP
	result._ammo_total = 0
	result._assembly_complete = true
	result._fire_callbacks = {}
	result._muzzle_effect_table = {}
	result._parts = {}
	result._setup = {}
	result:_update_stats_values(true)
	result._next_fire_allowed = 0
	result:update_next_shooting_time()

	return result
end

function NoMA:CheckOutfit(peer)
	local outfit_string = peer and peer:profile('outfit_string') or ''
	if outfit_string == '' then
		return
	end

	local profile = self:GetPlayerProfile(peer)
	if not profile or outfit_string == profile.outfit_string then
		return
	elseif not profile.locked then
		self:UninitializePlayerProfile(peer:id())
		profile = self:GetPlayerProfile(peer)
		if not profile then
			return
		end
	end

	profile.outfit_string = outfit_string
	local outfit = outfit_string:split(' ') or {}

	-- weapons
	profile.weapons[2].factory_id = outfit[managers.blackmarket:outfit_string_index('primary')]
	profile.weapons[2].skin = outfit[managers.blackmarket:outfit_string_index('primary_cosmetics')]
	local primary = self:GetWeaponId(profile.weapons[2].factory_id)
	profile.weapons[2].weapon_id = primary
	local primary_blueprint_string = outfit[managers.blackmarket:outfit_string_index('primary_blueprint')]:gsub('_', ' ')
	profile.weapons[2].equipped_mods = managers.weapon_factory:unpack_blueprint_from_string(profile.weapons[2].factory_id, primary_blueprint_string)

	profile.weapons[1].factory_id = outfit[managers.blackmarket:outfit_string_index('secondary')]
	profile.weapons[1].skin = outfit[managers.blackmarket:outfit_string_index('secondary_cosmetics')]
	local secondary = self:GetWeaponId(profile.weapons[1].factory_id)
	profile.weapons[1].weapon_id = secondary
	local secondary_blueprint_string = outfit[managers.blackmarket:outfit_string_index('secondary_blueprint')]:gsub('_', ' ')
	profile.weapons[1].equipped_mods = managers.weapon_factory:unpack_blueprint_from_string(profile.weapons[1].factory_id, secondary_blueprint_string)

	for _, weapon in ipairs(profile.weapons) do
		if not weapon.weapon_id then
			self:MarkCheater(peer, 'unknown weapon')
			return
		end

		weapon.name_id = tweak_data.weapon[weapon.weapon_id].name_id
		weapon.name = managers.localization:text(weapon.name_id)
		local _, weapon_level, _ = managers.upgrades:get_value(weapon.weapon_id)
		if weapon_level > profile.level then
			self:MarkCheater(peer, string.format('using %s at level %i (unlocked at %i)', weapon.name, profile.level, weapon_level))
		end

		if not game_state_machine:verify_game_state(GameStateFilters.lobby) then
			weapon.fake_base = self:MakeFakeWeaponBase(weapon.factory_id, weapon.equipped_mods, weapon.weapon_id)
		end
	end

	-- melee
	profile.melee.weapon_id = outfit[managers.blackmarket:outfit_string_index('melee_weapon')]
	local mtd = tweak_data.blackmarket.melee_weapons[profile.melee.weapon_id]
	profile.melee.current_stats = mtd.stats
	profile.melee.melee_damage_delay = mtd.melee_damage_delay
	profile.melee.name = managers.localization:text(mtd.name_id)
	if profile.melee.weapon_id == 'weapon' then
		local available_weapon_mods = managers.weapon_factory:get_parts_from_weapon_id(primary)
		if available_weapon_mods and available_weapon_mods.bayonet then
			for _, bayonet in ipairs(available_weapon_mods.bayonet) do
				for _, mod in ipairs(profile.weapons[2].equipped_mods) do
					if mod == bayonet then
						profile.melee.current_stats = tweak_data.weapon.factory.parts[bayonet].stats
						goto melee_end
					end
				end
			end
		end
	end
	::melee_end::

	-- saw
	if tweak_data.weapon[secondary].category == 'saw' then
		self:CheckUpgrade(peer, 'saw')
		self:CheckUpgrade(peer, 'saw_secondary')
	end

	-- ictv
	if tonumber(peer:armor_id(false):split('_')[2] or 0) >= 7 then
		self:CheckUpgrade(peer, 'body_armor6')
	end

	-- deployable
	local deployable = outfit[managers.blackmarket:outfit_string_index('deployable')]
	if deployable and deployable ~= 'nil' then
		local amount = tonumber(outfit[managers.blackmarket:outfit_string_index('deployable_amount')] or '0')
		if deployable == 'doctor_bag' then
			if amount > 1 then
				self:CheckUpgrade(peer, 'doctor_bag_quantity')
			end

		elseif deployable == 'ammo_bag' then
			if amount > 1 then
				self:CheckUpgrade(peer, 'ammo_bag_quantity')
			end

		elseif deployable == 'trip_mine' then
			if amount >= 14 then
				self:CheckUpgrade(peer, 'trip_mine_quantity_increase_2')
			elseif amount >= 7 then
				self:CheckUpgrade(peer, 'trip_mine_quantity_increase_1')
			end

		elseif deployable:find('sentry_gun') then
			if deployable == 'sentry_gun_silent' then
				self:CheckUpgrade(peer, 'sentry_gun_silent')
			end
			if amount == 2 then
				self:CheckUpgrade(peer, 'sentry_gun_quantity_1')
			elseif amount > 2 then
				self:CheckUpgrade(peer, 'sentry_gun_quantity_2')
			end

		elseif deployable == 'ecm_jammer' then
			if amount > 1 then
				self:CheckUpgrade(peer, 'ecm_jammer_quantity_increase_1')
			end

		elseif deployable == 'first_aid_kit' then
			if amount > 11 then
				self:CheckUpgrade(peer, 'first_aid_kit_quantity_increase_2')
			elseif amount > 4 then
				self:CheckUpgrade(peer, 'first_aid_kit_quantity_increase_1')
			end

		elseif deployable == 'bodybags_bag' then
			if amount > 1 then
				self:CheckUpgrade(peer, 'bodybags_bag_quantity')
			elseif amount == 1 then
				self:CheckUpgrade(peer, 'bodybags_bag')
			end
		end
	end

	deployable = outfit[managers.blackmarket:outfit_string_index('secondary_deployable')]
	if deployable and deployable ~= 'nil' then
		self:CheckUpgrade(peer, 'second_deployable_1')
	end

	-- throwable
	local throwable = outfit[managers.blackmarket:outfit_string_index('grenade')]
	local tdt = tweak_data.blackmarket.projectiles[throwable]
	profile.throwable.id = throwable
	profile.throwable.name = managers.localization:text(tdt.name_id)
	profile.throwable.reusable = tdt and tdt.throwable and not tdt.is_a_grenade
end

local function _has_category(categories, category)
	return categories and table.contains(categories, category)
end

local wctg2upgname = {
	pistol = 'pistol_magazine_capacity_inc_1',
	shotgun = 'shotgun_magazine_capacity_inc_1',
	assault_rifle = 'player_automatic_mag_increase_1',
	lmg = 'player_automatic_mag_increase_1',
	smg = 'player_automatic_mag_increase_1'
}

function NoMA:LogWeaponDetails(weapon)
	logf('[NoMA] %i mods on %s (skin %s):',
		#weapon.equipped_mods, weapon.name, weapon.skin)

	for _, mod_id in pairs(weapon.equipped_mods) do
		local part = tweak_data.weapon.factory.parts[mod_id]
		logf('[NoMA]    %s (%s%s)',
			managers.localization:text(part.name_id),
			part.type or '',
			part.sub_type and (', ' .. part.sub_type) or ''
		)
	end

	local skin_id, skin_boost = weapon.skin and weapon.skin:match('^([^-]+).*([^-]+)$')
	local skin_specs = skin_id and tweak_data.blackmarket.weapon_skins[skin_id]
	if skin_specs then
		logf('[NoMA]    %s with %s',
			managers.localization:text(skin_specs.name_id),
			skin_boost == '1' and skin_specs.bonus or 'no boost'
		)
	end
end

function NoMA:GetWeaponById(profile, weapon_id)
	for _, weapon in ipairs(profile.weapons) do
		if weapon.weapon_id == weapon_id then
			return weapon
		end
	end
end

function NoMA:CheckWeaponAmmo(peer, weapon, clip_base_mod, total_ammo_mod, recv_ammo_max, recv_clip_ammo_max)
	local weapon_tweak_data = tweak_data.weapon[weapon.weapon_id]
	local factory = tweak_data.weapon.factory

	-- mods
	local weapon_factory = factory[weapon.factory_id]
	for _, mod_id in pairs(weapon.equipped_mods) do
		local part = factory.parts[mod_id]
		if not part then
			logf('[NoMA] %s (%s) Unknown mod for %s: %s',
				peer:name(), peer:skills(), weapon.name, mod_id)
			self:MarkCheater(peer, string.format('unknown mod for %s: %s', weapon.name, mod_id))
			return
		end

		if not weapon_factory.uses_parts or not table.contains(weapon_factory.uses_parts, mod_id) then
			logf('[NoMA] %s (%s) Forbidden mod for %s: %s',
				peer:name(), peer:skills(), weapon.name, managers.localization:text(part.name_id))
			self:MarkCheater(peer, string.format('forbidden mod for %s: %s',
				weapon.name, managers.localization:text(part.name_id)))
			return
		end
	end

	-- mag size
	local function upgrade_blocked(category, upgrade)
		if not weapon_tweak_data.upgrade_blocks then
			return false
		end
		if not weapon_tweak_data.upgrade_blocks[category] then
			return false
		end
		return table.contains(weapon_tweak_data.upgrade_blocks[category], upgrade)
	end

	if clip_base_mod < recv_clip_ammo_max then
		local mag_ok
		if not upgrade_blocked('weapon', 'clip_ammo_increase') then
			local wctgs = weapon_tweak_data.categories
			local upgrade_name
			for ctg, upg_name in pairs(wctg2upgname) do
				if _has_category(wctgs, ctg) then
					if ctg == 'pistol' and _has_category(wctgs, 'revolver') then
						-- qued
					else
						upgrade_name = upg_name
					end
					break
				end
			end
			if upgrade_name then
				local upg_def = tweak_data.upgrades.definitions[upgrade_name].upgrade
				local mult = _has_category(wctgs, 'akimbo') and 2 or 1
				for _, clip_skill in pairs(tweak_data.upgrades.values[upg_def.category][upg_def.upgrade]) do
					local final_clip_skill = clip_skill * mult
					if clip_base_mod + final_clip_skill == recv_clip_ammo_max or clip_base_mod + final_clip_skill > recv_ammo_max then
						mag_ok = true
						self:CheckUpgrade(peer, upgrade_name)
					end
				end
			end
		end
		if not mag_ok then
			logf('[NoMA] %s (%s) Weird mag size for %s: received %i, got base of %i',
				peer:name(), peer:skills(), weapon.name, recv_clip_ammo_max, clip_base_mod)
			self:LogWeaponDetails(weapon)
			self:MarkCheater(peer, string.format('weird mag size for %s, received %i, got base of %i',
				weapon.name, recv_clip_ammo_max, clip_base_mod))
		end
	end

	-- ammo max
	local function get_ammo_max(ammo_max_mul)
		ammo_max_mul = ammo_max_mul + ammo_max_mul * total_ammo_mod
		return math.round(tweak_data.weapon[weapon.weapon_id].AMMO_MAX * ammo_max_mul)
	end

	if get_ammo_max(1) == recv_ammo_max then
		return
	end

	local ammo_max_multiplier_fl = tweak_data.upgrades.values.player.extra_ammo_multiplier[1]
	if weapon_tweak_data.category == 'akimbo' then
		local profile = self:GetPlayerProfile(peer)

		local has_perk_hitman = profile.perk_id == 5 and profile.perk_rank >= 9
		local multiplier = 1
		if has_perk_hitman then
			multiplier = multiplier * tweak_data.upgrades.values.akimbo.extra_ammo_multiplier[2]
		end

		if get_ammo_max(multiplier) == recv_ammo_max then
			return

		elseif get_ammo_max(multiplier * ammo_max_multiplier_fl) == recv_ammo_max then
			self:CheckUpgrade(peer, 'extra_ammo_multiplier1')
			return

		elseif get_ammo_max(multiplier * tweak_data.upgrades.values.akimbo.extra_ammo_multiplier[1]) == recv_ammo_max then
			self:CheckUpgrade(peer, 'akimbo_extra_ammo_multiplier_1')
			return

		elseif get_ammo_max(multiplier * ammo_max_multiplier_fl * tweak_data.upgrades.values.akimbo.extra_ammo_multiplier[1]) == recv_ammo_max then
			self:CheckUpgrade(peer, 'akimbo_extra_ammo_multiplier_1')
			self:CheckUpgrade(peer, 'extra_ammo_multiplier1')
			return
		end

	elseif get_ammo_max(ammo_max_multiplier_fl) == recv_ammo_max then
		self:CheckUpgrade(peer, 'extra_ammo_multiplier1')
		return

	elseif weapon_tweak_data.category == 'saw' then
		local ammo_max_multiplier_saw = tweak_data.upgrades.values.saw.extra_ammo_multiplier[1]
		if get_ammo_max(ammo_max_multiplier_saw) == recv_ammo_max then
			self:CheckUpgrade(peer, 'saw_extra_ammo_multiplier')
			return
		elseif get_ammo_max(ammo_max_multiplier_saw * ammo_max_multiplier_fl) == recv_ammo_max then
			self:CheckUpgrade(peer, 'extra_ammo_multiplier1')
			self:CheckUpgrade(peer, 'saw_extra_ammo_multiplier')
			return
		end
	end

	logf('[NoMA] %s (%s) Weird total ammo for %s: received %i, got base of %i (%i with FL)',
		peer:name(), peer:skills(), weapon.name, recv_ammo_max, get_ammo_max(1), get_ammo_max(ammo_max_multiplier_fl))
	self:LogWeaponDetails(weapon)
	self:MarkCheater(peer, string.format('weird total ammo for %s: received %i, got base of %i (%i with FL)',
		weapon.name, recv_ammo_max, get_ammo_max(1), get_ammo_max(ammo_max_multiplier_fl)))
end

function NoMA:GetWeaponStats(factory_id, weapon_id, blueprint, cosmetics)
	local tdw = tweak_data.weapon[weapon_id]
	local base_stats = tdw.stats
	local stats = base_stats and deep_clone(base_stats) or {}
	local parts_stats = managers.weapon_factory:get_stats(factory_id, blueprint)
	local modifier_stats = tdw.stats_modifiers
	local bonus_stats = cosmetics and cosmetics.bonus and cosmetics.data and cosmetics.data.bonus and tweak_data.economy.bonuses[cosmetics.data.bonus] and tweak_data.economy.bonuses[cosmetics.data.bonus].stats or {}
	if managers.job:is_current_job_competitive() or managers.weapon_factory:has_perk('bonus', factory_id, blueprint) then
		bonus_stats = {}
	end
	local twdws = tweak_data.weapon.stats
	for stat, _ in pairs(stats) do
		if parts_stats[stat] then
			stats[stat] = stats[stat] + parts_stats[stat]
		end
		if bonus_stats[stat] then
			stats[stat] = stats[stat] + bonus_stats[stat]
		end
		stats[stat] = math.clamp(stats[stat], 1, #twdws[stat])
	end
	local current_stats = {}
	for stat, i in pairs(stats) do
		current_stats[stat] = twdws[stat][i]
		if modifier_stats and modifier_stats[stat] then
			current_stats[stat] = current_stats[stat] * modifier_stats[stat]
		end
	end
	local fire_rate = tdw.auto and tdw.auto.fire_rate
	current_stats.auto_rof = fire_rate and (1 / fire_rate)
	return current_stats
end

function NoMA:CheckAmmo(peer, selection_index, max_clip, current_clip, current_left, max)
	local profile = self:GetPlayerProfile(peer)

	local weapon = profile.weapons[selection_index]
	if not weapon then
		return
	end

	if not weapon.ammo_checked then
		if not weapon.weapon_id then
			logf('[NoMA] %s (%s) CheckAmmo() requires a valid weapon_id', profile.name, profile.skills)
			return
		end

		weapon.ammo_checked = true
		weapon.recv_clip_ammo_max = max_clip
		weapon.recv_ammo_max = max

		if not tweak_data.weapon[weapon.weapon_id] then
			logf('[NoMA] %s (%s) Weird weapon_id: received %s',
				profile.name, profile.skills, tostring(weapon.weapon_id))
			self:MarkCheater(peer, string.format('weird weapon_id: received %s', tostring(weapon.weapon_id)))
			return
		end

		for _, default_part in ipairs(managers.weapon_factory:get_default_blueprint_by_factory_id(weapon.factory_id)) do
			table.delete(weapon.equipped_mods, default_part)
		end
		local cs = weapon.skin:split('-')
		local cosmetics = {
			id = cs[1] ~= 'nil' and cs[1] or nil,
			quality = cs[2],
			bonus = cs[3] == '1',
			data = cs[1] ~= 'nil' and tweak_data.blackmarket.weapon_skins[cs[1]] or nil
		}
		local current_stats = self:GetWeaponStats(weapon.factory_id, weapon.weapon_id, weapon.equipped_mods, cosmetics)
		weapon.current_stats = current_stats

		self:CheckWeaponAmmo(peer, weapon, tweak_data.weapon[weapon.weapon_id].CLIP_AMMO_MAX + current_stats.extra_ammo, current_stats.total_ammo_mod, max, max_clip)
	end

	if current_clip < 0 or current_clip > weapon.recv_clip_ammo_max then
		logf('[NoMA] %s (%s) Magazine is abnormally filled! Got %i out of %i',
			profile.name, profile.skills, current_clip, weapon.recv_clip_ammo_max)
		self:MarkCheater(peer, string.format('magazine is abnormally filled! Got %i out of %i', current_clip, weapon.recv_clip_ammo_max))
	end

	if max_clip ~= weapon.recv_clip_ammo_max then
		logf('[NoMA] %s (%s) Size of magazine has changed! %i to %i',
			profile.name, profile.skills, weapon.recv_clip_ammo_max, max_clip)
		self:MarkCheater(peer, string.format('size of magazine has changed from %i to %i', weapon.recv_clip_ammo_max, max_clip))
		weapon.recv_clip_ammo_max = max_clip
	end

	if max ~= weapon.recv_ammo_max then
		logf('[NoMA] %s (%s) Ammo quantity has changed! %i to %i',
			profile.name, profile.skills, weapon.recv_ammo_max, max)
		self:MarkCheater(peer, string.format('ammo quantity has changed from %i to %i', weapon.recv_ammo_max, max))
		weapon.recv_ammo_max = max
	end
end

function NoMA:CheckArmor(peer, armor_pct)
	local profile = self:GetPlayerProfile(peer)

	if armor_pct > 0 and profile.previous_health_pct == 0 then
		profile.time_of_death = nil
	end

	if armor_pct == 100 then
		-- qued
	elseif profile.perk_id == 9 and profile.perk_rank >= 3 then
		-- Sociopath
	elseif profile.perk_id == 15 and profile.perk_rank >= 1 then
		-- Anarchist
	elseif profile.perk_id == 16 and profile.perk_rank >= 1 then
		-- Biker
	elseif armor_pct > profile.previous_armor_pct then
		self:CheckUpgrade(peer, 'player_headshot_regen_armor_bonus_1')
	end

	profile.previous_armor_pct = armor_pct
end

local function round_timer(t)
	return math.round(t * 10) / 10 -- *sigh*
end

function NoMA:GetWinningCombinations(base_timer, multipliers, peer_timer, u_id_rk, comb, results)
	for i = u_id_rk, #multipliers do
		for j = 1, #multipliers[i] do
			local comb_ext = comb .. tostring(i) .. ',' .. tostring(j) .. ';'
			local new_base_timer = base_timer * multipliers[i][j]
			if round_timer(new_base_timer) == peer_timer then
				results[#results + 1] = comb_ext
				-- no need to continue on this path since all multipliers are on the same side compared to 1
			else
				for k = u_id_rk + 1, #multipliers do
					self:GetWinningCombinations(new_base_timer, multipliers, peer_timer, k, comb_ext, results)
				end
			end
		end
	end
end

function NoMA:ValidateTimerUpgrades(peer, profile, interaction_id, type_index, twd, base_timer, upgrade_timer_multiplier, upgrade_timer_multipliers)
	local is_ok = false

	profile.interaction_timers[type_index] = profile.interaction_timers[type_index] or {}
	if profile.interaction_timers[type_index][interaction_id] then
		if profile.interaction_timers[type_index][interaction_id] == profile.previous_interaction_timer then
			return
		end

	elseif upgrade_timer_multipliers then
		local multipliers = {}
		for u_id, u in ipairs(upgrade_timer_multipliers) do
			for level, multiplier in ipairs(tweak_data.upgrades.values[u.category][u.upgrade]) do
				multipliers[u_id] = multipliers[u_id] or {}
				multipliers[u_id][level] = multiplier
			end
		end
		local combs = {}
		self:GetWinningCombinations(base_timer, multipliers, profile.previous_interaction_timer, 1, '', combs)
		if #combs > 0 then
			is_ok = true
			if #combs == 1 then
				for _, comb in pairs(combs) do
					for _, c in pairs(comb:split(';')) do
						local ids = c:split(',')
						local upg = upgrade_timer_multipliers[tonumber(ids[1])]
						self:CheckUpgrade(peer, nil, upg.category, upg.upgrade, ids[2])
					end
				end
			end
		end

	elseif upgrade_timer_multiplier then
		for level, multiplier in ipairs(tweak_data.upgrades.values[upgrade_timer_multiplier.category][upgrade_timer_multiplier.upgrade]) do
			if round_timer(base_timer * multiplier) == profile.previous_interaction_timer then
				is_ok = true
				self:CheckUpgrade(peer, nil, upgrade_timer_multiplier.category, upgrade_timer_multiplier.upgrade, level)
				break
			end
		end
	end

	if is_ok then
		logf('[NoMA] %s (%s) Timer for %s/%i validated to %.1f sec',
			profile.name, profile.skills, interaction_id, type_index, profile.previous_interaction_timer)
		profile.interaction_timers[type_index][interaction_id] = profile.previous_interaction_timer
	else
		logf('[NoMA] %s (%s) Timer mismatch for %s/%i! Cannot find multiplier combination to get %.1f sec (base is %.1f sec)',
			profile.name, profile.skills, interaction_id, type_index, profile.previous_interaction_timer or -1, base_timer)
		if not profile.previous_interaction_timer or base_timer > profile.previous_interaction_timer then
			local interaction = tweak_data.interaction[interaction_id]
			local descr = interaction and interaction.action_text_id and managers.localization:text(interaction.action_text_id):lower() or interaction_id
			self:MarkCheater(peer, string.format('timer mismatch for %s! Cannot find multiplier combination to get %.1f sec (base is %.1f sec)',
				descr, profile.previous_interaction_timer or -1, base_timer))
		end
	end
end

function NoMA:ValidateTimer(peer, profile, interaction_id, type_index, unit)
	local twd, base_timer, upgrade_timer_multiplier, upgrade_timer_multipliers
	type_index = type_index or 1

	if type_index == 1 then
		twd = tweak_data.interaction[interaction_id]
		if twd then
			base_timer = twd.timer
			upgrade_timer_multiplier = twd.upgrade_timer_multiplier or { category = 'carry', upgrade = 'interact_speed_multiplier' }
			upgrade_timer_multipliers = twd.upgrade_timer_multipliers
		end

	elseif type_index == 2 then
		twd = tweak_data.equipments[interaction_id]
		if twd then
			base_timer = twd.deploy_time
			upgrade_timer_multiplier = twd.upgrade_deploy_time_multiplier
			upgrade_timer_multipliers = twd.upgrade_deploy_time_multipliers
		end

	else -- playermaskoff
		return
	end

	-- requirements
	if twd and twd.requires_upgrade then
		self:CheckUpgrade(peer, twd.requires_upgrade.category .. '_' .. twd.requires_upgrade.upgrade)
	end

	-- interaction message may arrive before unit is created (happens in client-to-client case)
	if not alive(unit) then
		return
	end

	-- timer validity
	local interaction = unit:interaction()
	base_timer = interaction and interaction._override_timer_value or base_timer
	if base_timer then
		if interaction_id == 'corpse_alarm_pager' then
			-- qued
		elseif interaction and interaction:_get_modified_timer() then -- everybody has interact_speed_multiplier
			base_timer = round_timer(interaction:_get_modified_timer())
		else
			base_timer = base_timer * managers.player:crew_ability_upgrade_value('crew_interact', 1)
		end

		if twd and base_timer > 0 and round_timer(base_timer) ~= profile.previous_interaction_timer then
			self:ValidateTimerUpgrades(peer, profile, interaction_id, type_index, twd, base_timer, upgrade_timer_multiplier, upgrade_timer_multipliers)
		end
	end
end

function NoMA:InitTimer(peer, interaction_id, timer)
	local profile = self:GetPlayerProfile(peer)
	profile.previous_interaction_start = TimerManager:game():time()
	profile.previous_interaction_id = ''
	profile.previous_interaction_timer = round_timer(timer)
	-- NB: can't validate timer here since unit is required to know if there is an override
end

function NoMA:CheckElapsedTime(peer, interaction_id)
	local profile = self:GetPlayerProfile(peer)
	if not profile.previous_interaction_start then
		return
	end

	if not profile.previous_interaction_timer then
		logf('[NoMA] %s (%s) Timer was not initialized!',
			profile.name, profile.skills)
		self:MarkCheater(peer, 'timer was not initialized')
	end

	profile.previous_interaction_id = interaction_id

	if self.timespeedchange_t > profile.previous_interaction_start then
		return
	end

	-- announced timer vs time past
	local t = TimerManager:game():time()
	local dt = t - profile.previous_interaction_start
	local qos = peer:qos()
	local ping_sec = qos.ping / 1000

	profile.persistent.timers_total = profile.persistent.timers_total + 1
	profile.persistent.timers_sum = profile.persistent.timers_sum + profile.previous_interaction_timer
	profile.persistent.timers_real_sum = profile.persistent.timers_real_sum + dt

	if dt - profile.previous_interaction_timer < -0.1 - ping_sec then
		if t - self.spawn_t < 15 and interaction_id == 'mask_on_action' then
			-- discard warning due to interaction started while in blackscreen
			return
		end

		profile.persistent.timers_short = profile.persistent.timers_short + 1
		if qos.packet_loss > profile.previous_packet_loss then
			profile.previous_packet_loss = qos.packet_loss
			profile.persistent.network_prbs = profile.persistent.network_prbs + 1
		end

		logf('[NoMA] %s (%s) Elapsed time not equal to timer for %s! Got %.1f sec instead of %.1f sec (latency = %.2f, packet_loss = %i, window = %.1f)',
			profile.name, profile.skills, interaction_id, dt, profile.previous_interaction_timer, ping_sec, qos.packet_loss, qos.window)

		-- not reliable enough to give the cheater mark, player has to decide by himself
		local overall_wait_rate = 100 * profile.persistent.timers_real_sum / profile.persistent.timers_sum
		if overall_wait_rate < 75 and qos.ping < 300 then
			local msg = string.format("%s's interaction time is too short!\nOn %i timers, %i were too short (detected %i network problems).\nHis overall wait time rate is %.1f %% (a low value means cheating).",
				profile.name, profile.persistent.timers_total, profile.persistent.timers_short, profile.persistent.network_prbs, overall_wait_rate)
			self:Tell(msg)
		end
	end
end

function NoMA:CheckInteraction(peer, interaction_id, unit, unit_id)
	if interaction_id == 'corpse_alarm_pager' then
		if alive(unit) and unit:character_damage() and not unit:character_damage():dead() then
			-- for pager of intimidated cops, sync_interacted arrives BEFORE sync_teammate_progress/start
			return
		end
	end

	local profile = self:GetPlayerProfile(peer)
	local twd, base_timer, type_index

	if unit_id == -2 then
		type_index = 2
		twd = tweak_data.equipments[interaction_id]
		base_timer = twd and twd.deploy_time or nil
	else
		type_index = 1
		twd = tweak_data.interaction[interaction_id]
		base_timer = twd and twd.timer or nil
	end

	if twd then
		if twd.requires_upgrade then
			self:CheckUpgrade(peer, twd.requires_upgrade.category .. '_' .. twd.requires_upgrade.upgrade)
		end

		if base_timer then
			self:ValidateTimer(peer, profile, interaction_id, type_index, unit)

			-- NB: timer requires previous progression...
			if profile.previous_interaction_id and interaction_id ~= profile.previous_interaction_id then
				local previous_interaction = profile.previous_interaction_id:match('^(.*)open$')
				local interaction = interaction_id:match('^(.*)close$')
				if not (interaction and interaction == previous_interaction) then
					-- if interaction_id == 'carry_drop' and not unit:interaction()._has_modified_timer then -- ...except for bags catched mid-air
					-- can't use the code above because if the peer catch the bag right before it lands,
					-- with network lag we'll see the bag already on the ground => false positive
					if peer:id() == 1 then
						-- nothing, could be a bot interaction
					elseif interaction_id ~= 'carry_drop' and interaction_id ~= 'painting_carry_drop' then
						logf('[NoMA] %s (%s) Interaction mismatch! Got %s instead of %s',
							profile.name, profile.skills, tostring(interaction_id), tostring(profile.previous_interaction_id))
						self:MarkCheater(peer, "progression bypassed ('" .. tostring(interaction_id) .. "' instead of '" .. tostring(profile.previous_interaction_id) .. "')")
					end
				end
			end
		end
	end

	profile.previous_interaction_id = ''
end

function NoMA:CheckInspireCooldown(peer)
	local t = TimerManager:game():time()
	local profile = self:GetPlayerProfile(peer)
	local cooldown = tweak_data.upgrades.values.cooldown.long_dis_revive[1][2]
	local dt = t - profile.inspire_t
	if dt < cooldown * 0.9 then
		logf('[NoMA] %s (%s) Inspire cooldown: %.1f sec instead of %.1f',
			profile.name, profile.skills, dt, cooldown)
		self:MarkCheater(peer, string.format('inspire cooldown (%.1f sec instead of %.1f)', dt, cooldown))
	end
	profile.inspire_t = t
end

function NoMA:GetTextInfo(peer_id)
	local result = ''

	local hacc = self.hit_accounting[peer_id]
	if hacc and hacc.attacked_nr > 0 then
		result = string.format('hit by %0.1f%% of %i shots',
			(hacc.health_hit_nr + hacc.armor_hit_nr) / hacc.attacked_nr * 100, hacc.attacked_nr)
	end

	return result
end
