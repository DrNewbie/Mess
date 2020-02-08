local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local tmp_vec = Vector3()
local vnull = Vector3(0, 0, 0)

local nma_original_copdamage_syncdamagebullet = CopDamage.sync_damage_bullet
function CopDamage:sync_damage_bullet(attacker_unit, damage_percent, i_body, hit_offset_height, variant, death)
	self:nma_eval_damage('bullet', attacker_unit, damage_percent, death, variant, i_body, hit_offset_height)
	nma_original_copdamage_syncdamagebullet(self, attacker_unit, damage_percent, i_body, hit_offset_height, variant, death)
end

local nma_original_copdamage_syncdamageexplosion = CopDamage.sync_damage_explosion
function CopDamage:sync_damage_explosion(attacker_unit, damage_percent, i_attack_variant, death, direction, weapon_unit)
	self:nma_eval_damage('explosion', attacker_unit, damage_percent, death, i_attack_variant, nil, nil, weapon_unit)
	nma_original_copdamage_syncdamageexplosion(self, attacker_unit, damage_percent, i_attack_variant, death, direction, weapon_unit)
end

local nma_original_copdamage_syncdamagefire = CopDamage.sync_damage_fire
function CopDamage:sync_damage_fire(attacker_unit, damage_percent, start_dot_dance_antimation, death, direction, weapon_type, weapon_id, healed)
	if not healed then
		local variant
		if mvector3.not_equal(direction, vnull) then
			-- can't be dot
		elseif weapon_type == CopDamage.WEAPON_TYPE_GRANADE then
			-- variant = tweak_data.projectiles[weapon_id].fire_dot_data
			variant = tweak_data.env_effect:molotov_fire().fire_dot_data -- *sighs*
		elseif weapon_type == CopDamage.WEAPON_TYPE_BULLET then
			if tweak_data.weapon.factory.parts[weapon_id].custom_stats then
				variant = tweak_data.weapon.factory.parts[weapon_id].custom_stats.fire_dot_data
			end
		elseif weapon_type == CopDamage.WEAPON_TYPE_FLAMER and tweak_data.weapon[weapon_id].fire_dot_data then
			variant = tweak_data.weapon[weapon_id].fire_dot_data
		end
		self:nma_eval_damage('fire', attacker_unit, damage_percent, death, variant, nil, nil, weapon_id)
	end
	nma_original_copdamage_syncdamagefire(self, attacker_unit, damage_percent, start_dot_dance_antimation, death, direction, weapon_type, weapon_id, healed)
end

local nma_original_copdamage_syncdamagedot = CopDamage.sync_damage_dot
function CopDamage:sync_damage_dot(attacker_unit, damage_percent, death, variant, hurt_animation, weapon_id)
	self:nma_eval_damage('dot', attacker_unit, damage_percent, death, variant, nil, nil, weapon_id)
	nma_original_copdamage_syncdamagedot(self, attacker_unit, damage_percent, death, variant, hurt_animation, weapon_id)
end

local nma_original_copdamage_syncdamagesimple = CopDamage.sync_damage_simple
function CopDamage:sync_damage_simple(attacker_unit, damage_percent, i_attack_variant, i_result, death)
	self:nma_eval_damage('simple', attacker_unit, damage_percent, death, i_attack_variant)
	nma_original_copdamage_syncdamagesimple(self, attacker_unit, damage_percent, i_attack_variant, i_result, death)
end

local nma_original_copdamage_syncdamagemelee = CopDamage.sync_damage_melee
function CopDamage:sync_damage_melee(attacker_unit, damage_percent, damage_effect_percent, i_body, hit_offset_height, variant, death)
	self:nma_eval_damage('melee', attacker_unit, damage_percent, death, variant, i_body, hit_offset_height)
	nma_original_copdamage_syncdamagemelee(self, attacker_unit, damage_percent, damage_effect_percent, i_body, hit_offset_height, variant, death)
end

local nma_original_copdamage_syncdamagetase = CopDamage.sync_damage_tase
function CopDamage:sync_damage_tase(attacker_unit, damage_percent, variant, death)
	self:nma_eval_damage('tase', attacker_unit, damage_percent, death, variant)
	nma_original_copdamage_syncdamagetase(self, attacker_unit, damage_percent, variant, death)
end

function CopDamage:nma_roll_critical_hit(attack_data)
	local damage = attack_data.damage
	if not attack_data.crit then
		return false, damage
	end
	if not self:can_be_critical(attack_data) then
		return false, damage
	end
	local critical_hits = self._char_tweak.critical_hits
	local critical_damage_mul = critical_hits and critical_hits.damage_mul or self._char_tweak.headshot_dmg_mul
	damage = critical_damage_mul and damage * critical_damage_mul or self._health * 10
	return true, damage
end

function CopDamage:nma_percentize(damage)
	return math.ceil(math.clamp(damage / self._HEALTH_INIT_PRECENT, 1, self._HEALTH_GRANULARITY))
end

function CopDamage:nma_damage_bullet(attack_data)
	local damage = attack_data.damage

	if self._is_halloween then -- TankCopDamage
		damage = math.min(damage, 235)
	end

	if self._char_tweak.DAMAGE_CLAMP_BULLET then
		damage = math.min(damage, self._char_tweak.DAMAGE_CLAMP_BULLET)
	end

	damage = damage * (self._marked_dmg_mul or 1) -- HVT basic

	if self._marked_dmg_mul and self._marked_dmg_dist_mul then -- HVT aced
		local dst = attack_data.distance --mvector3.distance(attack_data.origin, self._unit:position())
		local spott_dst = tweak_data.upgrades.values.player.marked_inc_dmg_distance[self._marked_dmg_dist_mul]
		if spott_dst[1] < dst then
			damage = damage * spott_dst[2]
		end
	end

	local critical_hit, crit_damage = self:nma_roll_critical_hit(attack_data) -- crits
	if critical_hit then
		damage = crit_damage
	end

	if tweak_data.character[self._unit:base()._tweak_table].priority_shout then
		damage = damage * managers.player:upgrade_value('weapon', 'special_damage_taken_multiplier', 1) -- ???
	end

	if attack_data.head then
		if not self._char_tweak.ignore_headshot and not self._damage_reduction_multiplier then -- headshot
			local headshot_multiplier = managers.player:upgrade_value('weapon', 'passive_headshot_damage_multiplier', 1) -- helmet popping
			damage = damage * self._char_tweak.headshot_dmg_mul * headshot_multiplier
		end
	elseif attack_data.wbase.get_add_head_shot_mul then -- bodyexpertise
		local add_head_shot_mul = attack_data.wbase:get_add_head_shot_mul()
		if add_head_shot_mul and self._char_tweak and self._char_tweak.access ~= 'tank' then
			local tweak_headshot_mul = math.max(0, self._char_tweak.headshot_dmg_mul - 1)
			local mul = tweak_headshot_mul * add_head_shot_mul + 1
			damage = damage * mul
		end
	end

	damage = self:_apply_damage_reduction(damage)

	local damage_percent = math.ceil(math.clamp(damage / self._HEALTH_INIT_PRECENT, 1, self._HEALTH_GRANULARITY))
	damage = damage_percent * self._HEALTH_INIT_PRECENT
	damage, damage_percent = self:_apply_min_health_limit(damage, damage_percent)

	return damage_percent
end

function CopDamage:nma_damage_fire(attack_data)
	local damage = attack_data.damage
	damage = self:_apply_damage_reduction(damage)
	damage = math.clamp(damage, 0, self._HEALTH_INIT)
	local damage_percent = math.ceil(damage / self._HEALTH_INIT_PRECENT)
	damage = damage_percent * self._HEALTH_INIT_PRECENT
	damage, damage_percent = self:_apply_min_health_limit(damage, damage_percent)

	local critical_hit, crit_damage = self:nma_roll_critical_hit(attack_data)
	if critical_hit then
		damage = crit_damage
	end
	if tweak_data.character[self._unit:base()._tweak_table].priority_shout then
		damage = damage * managers.player:upgrade_value('weapon', 'special_damage_taken_multiplier', 1)
	end

	if not self._damage_reduction_multiplier and attack_data.head then
		local headshot_multiplier = managers.player:upgrade_value('weapon', 'passive_headshot_damage_multiplier', 1)
		damage = damage * self._char_tweak.headshot_dmg_mul * headshot_multiplier
	end

	return damage_percent
end

function CopDamage:nma_damage_melee(attack_data)
	local damage = attack_data.damage

	local critical_hit, crit_damage = self:nma_roll_critical_hit(attack_data)
	if critical_hit then
		damage = crit_damage
	end

	damage = damage * (self._marked_dmg_mul or 1)
	damage = self:_apply_damage_reduction(damage)
	damage = math.clamp(damage, self._HEALTH_INIT_PRECENT, self._HEALTH_INIT)
	local damage_percent = math.ceil(damage / self._HEALTH_INIT_PRECENT)
	damage = damage_percent * self._HEALTH_INIT_PRECENT
	damage, damage_percent = self:_apply_min_health_limit(damage, damage_percent)

	return damage_percent
end

-- function CopDamage:nma_damage_simple(attack_data)
	-- local damage = attack_data.damage

	-- if self._unit:base():char_tweak().DAMAGE_CLAMP_SHOCK then
		-- damage = math.min(damage, self._unit:base():char_tweak().DAMAGE_CLAMP_SHOCK)
	-- end

	-- damage = math.clamp(damage, 0, self._HEALTH_INIT)
	-- local damage_percent = math.ceil(damage / self._HEALTH_INIT_PRECENT)
	-- damage = damage_percent * self._HEALTH_INIT_PRECENT
	-- damage, damage_percent = self:_apply_min_health_limit(damage, damage_percent)

	-- return damage_percent
-- end

local function _aquire_upgrade(id)
	local upgrade = tweak_data.upgrades.definitions[id]
	managers.upgrades:_aquire_upgrade(upgrade, id, true)
end

local function _unaquire_upgrade(id)
	local upgrade = tweak_data.upgrades.definitions[id]
	managers.upgrades:_unaquire_upgrade(upgrade, id)
end

local _options = {
	list = {},
	snapshots = {},

	reset = function(self)
		self.list = {}
		self.snapshots = {}
	end,

	make_option = function(self, name, limitable, upgrades, func_inc, func_reset, validated_upgrades)
		local min_value = 0
		if limitable and validated_upgrades then
			for i = #upgrades, 1, -1 do
				if validated_upgrades[upgrades[i]] then
					min_value = i
					break
				end
			end
		end

		local new_option = {
			value = 0,
			error_rate = 1,
			limitable = limitable,
			min_value = min_value,
			name = name or '',
			upgrades = upgrades,
			_inc = func_inc,
			_reset = func_reset,
			inc = function(self)
				self.value = self.value + 1
				if not limitable or not self.max_value or self.value <= self.max_value then
					return self:_inc()
				end
			end,
			reset = function(self)
				if self._reset then
					self:_reset()
				end
				self.value = 0
				if self.upgrades then
					for _, upgrade in ipairs(self.upgrades) do
						_unaquire_upgrade(upgrade)
					end
				end
				if self.limitable then
					for i = 1, self.min_value do
						self:inc()
					end
				end
			end,
		}
		table.insert(self.list, new_option)

		return new_option
	end,

	get_error_rate = function(self)
		local result = 1
		for _, option in ipairs(self.list) do
			result = result * option.error_rate
		end
		return result
	end,

	get_options_values = function(self)
		local values = {}
		for _, option in ipairs(self.list) do
			table.insert(values, option.value)
		end
		return values
	end,

	take_snapshot = function(self)
		table.insert(self.snapshots, self:get_options_values())
	end,

	find_common_points = function(self)
		local result = self.snapshots[1]
		if result then
			result = clone(result)
			for _, snapshot in ipairs(self.snapshots) do
				for i, v in ipairs(snapshot) do
					if result[i] ~= v then
						result[i] = math.min(result[i], v)
					end
				end
			end
		end
		return result
	end,

	get_checkable_upgrades = function(self)
		local result = {}
		local opts_values = self:find_common_points()
		if opts_values then
			for i, v in ipairs(opts_values) do
				local upgrades = self.list[i].upgrades
				if upgrades then
					for j = 1, v do
						local upgrade = upgrades[j]
						if not upgrade then
							break
						end
						table.insert(result, upgrade)
					end
				end
			end
		end
		return result, opts_values
	end,

	get_options_desc = function(self, value_overrides, glue)
		local result = ''
		local option = self.list[1]
		if option then
			result = option.name .. '=' .. (value_overrides and value_overrides[1] or option.value)
			glue = glue or ' '
			for i = 2, #self.list do
				option = self.list[i]
				result = result .. glue .. option.name .. '=' .. (value_overrides and value_overrides[i] or option.value)
			end
		end
		return result
	end,
}

function CopDamage:nma_eval_damage(category, attacker_unit, damage_percent_recv, death, variant, i_body, hit_offset_height, weapon_id)
	if self._immortal then
		return
	elseif self._lower_health_percentage_limit then
		return -- VIP
	elseif self._damage_reduction_multiplier then
		return -- jokers
	elseif not self._char_tweak.headshot_dmg_mul then
		return -- bots
	elseif not alive(attacker_unit) then
		return
	elseif attacker_unit:slot() ~= 3 then
		return
	end

	local profile, peer = NoMA:GetPlayerProfileByUnit(attacker_unit)
	if not profile then
		return
	end

	if category ~= 'melee' then
		if death and not self.is_civilian(self._unit:base()._tweak_table) then
			local max_multiplier = tweak_data.upgrades.values.player.melee_damage_stacking[1].max_multiplier
			profile.melee.bloodthirst_mul_tracker = math.min(max_multiplier, profile.melee.bloodthirst_mul_tracker + 1)
		end
	elseif variant == 0 then
		if damage_percent_recv == 1 then
			local record = managers.groupai:state():all_criminals()[attacker_unit:key()]
			if record and record.status == 'electrified' then
				NoMA:CheckUpgrade(peer, 'player_taser_malfunction')
			end
			return
		end
	elseif variant == 1 then -- shield_knock
		NoMA:CheckUpgrade(peer, 'player_shield_knock')
		return
	elseif variant == 2 then -- counter_tased
		NoMA:CheckUpgrade(peer, 'player_escape_taser_1')
		return
	elseif variant == 4 then -- expl_hurt/counter_spooc
		NoMA:CheckUpgrade(peer, 'player_counter_strike_spooc')
		return
	elseif variant == 5 then -- taser_tased
		local td = tweak_data.blackmarket.melee_weapons[profile.melee.weapon_id]
		if td.special_weapon ~= 'taser' then
			NoMA:MarkCheater(peer, managers.localization:text(td.name_id) .. ' should not have taser capabilities')
		end
	end

	local funcs = {
		bullet = self.nma_damage_bullet,
		-- explosion = self.nma_damage_explosion,
		fire = self.nma_damage_fire,
		melee = self.nma_damage_melee,
		-- simple = self.nma_damage_simple,
	}
	local func_damage = funcs[category]
	if not func_damage then
		return
	end

	local weapon_unit = attacker_unit:inventory():equipped_unit()
	local wbase = weapon_unit and weapon_unit:base()
	if not wbase then
		return
	end
	local weapon = profile.weapons[wbase:selection_index()]
	if not weapon then
		return
	end

	local fire_dot = category == 'fire' and variant
	local is_molotov = fire_dot and weapon_id == 'molotov'

	local data_holder
	if category == 'melee' then
		data_holder = profile.melee
	elseif is_molotov and profile.throwable.id == 'molotov' then -- can't tell if it's from a throwable or a grenade launcher
		data_holder = profile.throwable
	else
		data_holder = weapon
	end

	local stats_holder = data_holder
	if fire_dot then
		data_holder.dots = data_holder.dots or NoMA:MakeStatsTable()
		stats_holder = data_holder.dots
	end

	local t = TimerManager:game():time()
	if t - (managers.groupai:state()._phalanx_damage_reduction_last_increase or 0) < 2 then
		stats_holder.not_assessed_nr = stats_holder.not_assessed_nr + 1
		return
	end

	local is_saw, is_shotgun, is_saw_tank
	if category ~= 'melee' and not fire_dot then
		is_saw = wbase:is_category('saw')
		is_shotgun = wbase:is_category('shotgun')
		is_saw_tank = is_saw and self._unit:base()._tweak_table == 'tank' -- no! don't use :has_tag('tank')
	end

	local forced_headshot = false
	if i_body then
		local body = self._unit:body(i_body)
		if self._head_body_name then
			forced_headshot = body and body:name() == self._ids_head_body_name
		end
		if self._has_plate and body:name() == self._ids_plate_name then
			stats_holder.armor_pierced_nr = stats_holder.armor_pierced_nr + 1 -- don't forget that number of shots blocked by armor is unknown
			if profile.perk_id ~= 4 and profile.perk_ ~= 11 and weapon.fake_base:armor_piercing_chance() == 0 then -- rogue, grinder, snipers
				NoMA:CheckUpgrade(peer, 'player_ap_bullets_1') -- surefire aced
			end
		end
	end

	local base_error_rate = 1
	local required_points_t2 = { 3, 7, 999 }
	local required_points_t3 = { 6, 12, 999 }
	local required_points_t4 = { 20, 28, 999 }

	-- hacky mess... temporarily override stuff to be able to call local player functions with peer data
	local attacker_base = attacker_unit:base()
	local managers_player = managers.player
	local original_player_upgrades = managers_player._global.upgrades
	managers_player._global.upgrades = attacker_base._upgrade_levels -- husk _upgrades holds values, not levels!
	local original_player_temporary_upgrades = managers_player._global._temporary_upgrades
	managers_player._global._temporary_upgrades = {}
	local original_player_properties = managers_player._properties._properties
	managers_player._properties._properties = {}

	local original_damage = wbase._damage
	local original_weapon_id = wbase._name_id
	local original_current_stats = wbase._current_stats
	wbase._name_id = weapon.weapon_id
	wbase._damage_near = weapon.fake_base._damage_near
	wbase._damage_far = weapon.fake_base._damage_far
	wbase._current_stats = weapon.current_stats

	local attack_data = {
		damage = 0,
		variant = category, -- used in can_be_critical()
		weapon_unit = weapon_unit,
		perk_rank = profile.perk_rank,
		head = forced_headshot,
		crit = false,
		wbase = wbase,
	}

	-- helmet popping
	if profile.perk_rank >= 2 then
		_aquire_upgrade('weapon_passive_headshot_damage_multiplier')
	else
		_unaquire_upgrade('weapon_passive_headshot_damage_multiplier')
	end

	-- fast and furious
	if profile.perk_rank >= 8 then
		_aquire_upgrade('weapon_passive_damage_multiplier')
	else
		_unaquire_upgrade('weapon_passive_damage_multiplier')
	end

	-- see BlackMarketManager:damage_multiplier()
	-- and CopDamage:damage_*()
	-- and PlayerStandard:_check_action_primary_attack()
	-- and PlayerStandard:_do_melee_damage()
	_options:reset()

	-- charged melee
	local melee_weapon_type_damage_multiplier
	if category == 'melee' then
		melee_weapon_type_damage_multiplier = 'melee_' .. tostring(profile.melee.current_stats.weapon_type) .. '_damage_multiplier'

		local charge_rate = 0
		local stats = profile.melee.current_stats
		if profile.start_t > 0 then
			local max_charge_time = stats.charge_time
			local charge_time = profile.discharge_t - profile.start_t
			local offset = profile.melee.melee_damage_delay or 0
			charge_rate = math.clamp(charge_time - offset, 0, max_charge_time) / max_charge_time
		end
		attack_data.base_melee_damage = math.lerp(stats.min_damage, stats.max_damage, charge_rate)
		base_error_rate = base_error_rate * 1.06
	end

	-- overdog
	local dmg_mul_overdog = 1
	if category == 'melee' and (profile.perk_id == 8 or profile.perk_id == 9) and profile.perk_rank >= 1 then
		local max_melee_weapon_dmg_mul_stacks = tweak_data.upgrades.max_melee_weapon_dmg_mul_stacks
		_options:make_option(
			'overdog',
			false,
			{ 'melee_stacking_hit_damage_multiplier_1' },
			function(self)
				if self.value == 1 then
					_aquire_upgrade(self.upgrades[1])
				end
				if self.value <= max_melee_weapon_dmg_mul_stacks then
					dmg_mul_overdog = 1 + managers_player:upgrade_value('melee', 'stacking_hit_damage_multiplier', 0) * self.value
					return true
				end
			end,
			function()
				dmg_mul_overdog = 1
			end
		)
	end

	-- headshot
	if category == 'bullet' or category == 'fire' and not fire_dot then
		local option = _options:make_option(
			'headshot',
			true,
			nil,
			function(self)
				if self.value == 1 then
					attack_data.head = true
					return true
				end
			end,
			function()
				attack_data.head = false
			end
		)
		if forced_headshot then
			option.min_value = 1
		elseif category == 'bullet' then
			option.max_value = 0
		end
	end

	-- critical hit
	if category ~= 'simple' then
		if profile.pts_per_tree[12] >= required_points_t3[1] then
			_options:make_option(
				'critical_hit',
				false,
				nil,
				function()
					if not attack_data.crit then
						attack_data.crit = true
						return true
					end
				end,
				function()
					attack_data.crit = false
				end
			)
		end
	end

	-- graze
	local pt3 = profile.pts_per_tree[3]
	if category == 'simple' and variant == 5 and pt3 >= required_points_t4[1] then
		_options:make_option(
			'graze',
			true,
			{ 'snp_graze_damage_1', 'snp_graze_damage_2' },
			function(self)
				if pt3 >= required_points_t4[self.value] then
					_aquire_upgrade(self.upgrades[self.value])
					return true
				end
			end,
			nil,
			profile.upgrades
		)
	end

	-- underdog
	local pt4 = profile.pts_per_tree[4]
	if pt4 >= 1 and not fire_dot and category ~= 'melee' then
		_options:make_option(
			'underdog',
			false,
			{ 'player_damage_multiplier_outnumbered' },
			function(self)
				if self.value == 1 then
					_aquire_upgrade(self.upgrades[1])
					managers_player:activate_temporary_upgrade('temporary', 'dmg_multiplier_outnumbered')
					return true
				end
			end,
			function()
				managers_player:deactivate_temporary_upgrade('temporary', 'dmg_multiplier_outnumbered')
			end
		)
	end

	-- shotgun impact
	if is_shotgun and pt4 >= required_points_t2[1] then
		_options:make_option(
			'shotgun_impact',
			true,
			{ 'shotgun_damage_multiplier_1', 'shotgun_damage_multiplier_2' },
			function(self)
				if pt4 >= required_points_t2[self.value] then
					_aquire_upgrade(self.upgrades[self.value])
					return true
				end
			end,
			nil,
			profile.upgrades
		)
	end

	-- far away
	local inc_range_mul = 1
	if is_shotgun and pt4 >= required_points_t3[2] then
		_options:make_option(
			'far_away',
			false,
			{ 'shotgun_steelsight_range_inc_1' },
			function(self)
				if self.value == 1 then
					_aquire_upgrade(self.upgrades[1])
					inc_range_mul = managers_player:upgrade_value('shotgun', 'steelsight_range_inc', 1)
					return true
				end
			end,
			function()
				inc_range_mul = 1
			end,
			profile.upgrades
		)
	end

	-- overkill
	if category ~= 'melee' and not fire_dot and pt4 >= required_points_t4[1] then
		local lvl1_weapon = is_shotgun or is_saw
		_options:make_option(
			'overkill',
			false,
			{ 'player_overkill_damage_multiplier', 'player_overkill_all_weapons' },
			function(self)
				if lvl1_weapon then
					if self.value == 2 then -- no need to evaluate aced
						return
					end
				elseif self.value == 1 then -- no need to evaluate basic
					self.value = 2
				end
				if pt4 >= required_points_t4[self.value] then
					_aquire_upgrade(self.upgrades[1])
					managers_player:activate_temporary_upgrade('temporary', 'overkill_damage_multiplier')
					if self.value == 2 then
						-- TODO add check if last kill with shotgun/saw was <20sec
						_aquire_upgrade('player_overkill_all_weapons')
					end
					return true
				end
			end,
			function()
				managers_player:deactivate_temporary_upgrade('temporary', 'overkill_damage_multiplier')
			end,
			profile.upgrades
		)
	end

	-- body expertise
	if not forced_headshot and category == 'bullet' then
		local pt9 = profile.pts_per_tree[9]
		if wbase.get_add_head_shot_mul then
			_aquire_upgrade('weapon_automatic_head_shot_add_1')
			if not wbase:get_add_head_shot_mul() then
				pt9 = -1 -- nah, it's not utterly dirty
			end
			_unaquire_upgrade('weapon_automatic_head_shot_add_1')
		end
		if pt9 >= required_points_t4[1] then
			_options:make_option(
				'body_expertise',
				true,
				{ 'weapon_automatic_head_shot_add_1', 'weapon_automatic_head_shot_add_2' },
				function(self)
					if attack_data.head then
						-- qued
					elseif pt9 >= required_points_t4[self.value] then
						_aquire_upgrade(self.upgrades[self.value])
						return true
					end
				end,
				nil,
				profile.upgrades
			)
		end
	end

	-- high value target aced (has to be an option due to unsafe use of distance)
	if category == 'bullet' and self._marked_dmg_mul and self._marked_dmg_dist_mul then
		local threshold = tweak_data.upgrades.values.player.marked_inc_dmg_distance[self._marked_dmg_dist_mul][1]
		_options:make_option(
			'high_value_target',
			false,
			nil,
			function(self)
				if self.value == 1 then
					attack_data.distance = threshold + 1
					return true
				end
			end,
			function()
				attack_data.distance = 0
			end
		)
	end

	-- one handed talent
	local pt13 = profile.pts_per_tree[13]
	if category == 'bullet' and pt13 >= required_points_t3[1] and wbase:is_category('pistol') then
		_options:make_option(
			'one_handed_talent',
			true,
			{ 'pistol_damage_addend_1', 'pistol_damage_addend_2' },
			function(self)
				if pt13 >= required_points_t3[self.value] then
					_aquire_upgrade(self.upgrades[self.value])
					return true
				end
			end,
			nil,
			profile.upgrades
		)
	end

	-- trigger happy
	if category == 'bullet' and pt13 >= required_points_t4[1] and wbase:is_category('pistol') then
		local th_data = tweak_data.upgrades.values.pistol.stacking_hit_damage_multiplier[1]
		_options:make_option(
			'trigger_happy',
			false,
			{ 'pistol_stacking_hit_damage_multiplier_1' },
			function(self)
				if self.value <= th_data.max_stacks then
					managers_player:mul_to_property('trigger_happy', th_data.damage_bonus)
					return true
				end
			end,
			function()
				managers_player:remove_property('trigger_happy')
			end
		)
	end

	-- bloodthirst
	local dmg_mul_bloodthirst = 1
	local pt15 = profile.pts_per_tree[15]
	if category == 'melee' and pt15 >= 3 then
		local max_multiplier = tweak_data.upgrades.values.player.melee_damage_stacking[1].max_multiplier
		local option = _options:make_option(
			'bloodthirst',
			true,
			{ 'player_melee_damage_stacking_1' },
			function(self)
				if dmg_mul_bloodthirst == 1 then
					_aquire_upgrade(self.upgrades[1])
				end
				if dmg_mul_bloodthirst < max_multiplier then
					dmg_mul_bloodthirst = dmg_mul_bloodthirst + 1
					return true
				end
			end,
			function()
				dmg_mul_bloodthirst = 1
			end
		)
		-- limit range just a bit
		local extra = profile.net_latency < 150 and 0 or 1
		option.min_value = math.max(0, profile.melee.bloodthirst_mul_tracker - 1 - extra)
		option.max_value = math.min(max_multiplier, profile.melee.bloodthirst_mul_tracker - 1 + extra)
	end

	-- pumping iron
	local pumping_iron_upgrade = 'pumping_iron_dummy'
	if category == 'melee' and pt15 >= required_points_t2[1] then
		local is_civilian = managers.enemy:is_civilian(self._unit)
		local is_special = managers.groupai:state():is_enemy_special(self._unit)
		pumping_iron_upgrade = not is_civilian and not is_special and 'non_special_melee_multiplier' or 'melee_damage_multiplier'
		_options:make_option(
			'pumping_iron',
			true,
			{ 'player_non_special_melee_multiplier', 'player_melee_damage_multiplier' },
			function(self)
				if pt15 >= required_points_t2[self.value] then
					_aquire_upgrade(self.upgrades[self.value])
					return true
				end
			end,
			nil,
			profile.upgrades
		)
	end

	-- berserker basic
	local consider_berserker
	local dmg_mul_berserker = 1 -- multiplier used for both melee and other
	local function get_berserker_dmg_multiplier()
		local result = 1
		local health_ratio = profile.previous_health_pct / 100
		local primary_category = category == 'melee' and 'melee' or wbase:weapon_tweak_data().categories[1]
		local damage_health_ratio = managers_player:get_damage_health_ratio(health_ratio, primary_category)
		if damage_health_ratio > 0 then
			local upgrade_name = (category == 'melee' or is_saw) and 'melee_damage_health_ratio_multiplier' or 'damage_health_ratio_multiplier'
			local damage_ratio = damage_health_ratio
			result = result * (1 + managers_player:upgrade_value('player', upgrade_name, 0) * damage_ratio)
		end
		return result
	end

	if (category == 'melee' or is_saw) and pt15 >= required_points_t3[1] then
		consider_berserker = true
		_options:make_option(
			'berserker',
			false,
			{ 'player_melee_damage_health_ratio_multiplier' },
			function(self)
				if self.value == 1 then
					_aquire_upgrade(self.upgrades[1])
					dmg_mul_berserker = get_berserker_dmg_multiplier()
					self.error_rate = 1.02 -- see PlayerDamage:_send_set_health(), won't bother with variation of error rate
					return true
				end
			end,
			function(self)
				dmg_mul_berserker = 1
				self.error_rate = 1
			end,
			profile.upgrades
		)
	end

	-- berserker aced
	if is_saw or category == 'melee' or fire_dot then
		-- qued
	elseif pt15 >= required_points_t3[2] then
		consider_berserker = true
		_options:make_option(
			'berserker',
			false,
			{ 'player_damage_health_ratio_multiplier' },
			function(self)
				if self.value == 1 then
					_aquire_upgrade(self.upgrades[1])
					dmg_mul_berserker = get_berserker_dmg_multiplier()
					self.error_rate = 1.02 -- see PlayerDamage:_send_set_health()
					return true
				end
			end,
			function(self)
				dmg_mul_berserker = 1
				self.error_rate = 1
			end,
			profile.upgrades
		)
	end

	local result = 1 -- NOK/MEH/OK?/OK!
	local min_diff = self._HEALTH_GRANULARITY
	local damage_recv = damage_percent_recv * self._HEALTH_INIT_PRECENT
	local clamped_damage = damage_percent_recv == self._HEALTH_GRANULARITY -- clamped damages => superposed solutions => MEH

	local dis, target_vel, falloff_delta_dis = 0, 0, 0
	if is_shotgun then
		local action = self._unit:movement():get_action(2)
		if action and action:type() == 'walk' then
			target_vel = action._cur_vel
		end
		falloff_delta_dis = target_vel --* profile.net_latency

		local hit_pos = tmp_vec
		mvector3.set_static(hit_pos, 0, 0, hit_offset_height)
		mvector3.add(hit_pos, self._unit:movement():m_pos())
		dis = mvector3.distance(hit_pos, attacker_unit:position())
	end

	local function get_false_dis(dis)
		-- stay away from values too close to zero as dmg ratio gets high fast
		return math.min(dis, (wbase._damage_near + wbase._damage_far) * inc_range_mul - 50)
	end

	local function calc_peer_dis(damage_percent, damage_percent_recv)
		-- what distance would it be with peer damages
		local near = wbase._damage_near * inc_range_mul
		local far = wbase._damage_far * inc_range_mul
		local dmg_ratio = damage_percent_recv / damage_percent
		local falloff_ratio = 1 - (get_false_dis(dis) - near) / far
		local peer_dis = (1 - dmg_ratio * falloff_ratio) * far + near
		if peer_dis > 0 and peer_dis < near + far then
			return peer_dis
		end
	end

	local dbg_dmgs = {}
	local function eval_result(damage_percent, damage_percent_no_falloff)
		local is_a_match = 1
		local accountable = true
		local diff = math.abs(damage_percent - damage_percent_recv)
		local error_rate = base_error_rate * _options:get_error_rate()
		local error_rate_percent = math.ceil(self._HEALTH_GRANULARITY * (error_rate - 1))
		local acceptable = error_rate > 1 and diff <= error_rate_percent

		local peer_dis
		if is_shotgun then
			if damage_percent_recv > damage_percent_no_falloff * error_rate then
				return -- don't bother with unreachable amounts
			end
			local peer_has_no_falloff = damage_percent_no_falloff == damage_percent_recv
			if dis + (peer_has_no_falloff and 0 or falloff_delta_dis) > wbase._damage_near * inc_range_mul then -- inc_range_mul may vary
				accountable = false
				acceptable = false
			end
		end

		if accountable and diff == 0 then
			is_a_match = clamped_damage and 2 or 4
			_options:take_snapshot()
		elseif accountable and acceptable then
			is_a_match = 3
			_options:take_snapshot()
		elseif acceptable then
			is_a_match = 2
		elseif is_shotgun then
			peer_dis = calc_peer_dis(damage_percent, damage_percent_recv)
			if peer_dis then
				local dis_diff = math.abs(dis - peer_dis)
				if dis_diff < 50 then
					is_a_match = 4
					_options:take_snapshot()
				elseif dis_diff < math.max(100, target_vel) then
					is_a_match = 3
					_options:take_snapshot()
				elseif dis_diff < 2000 then -- there are limits to lag tolerance...
					is_a_match = 2
				end
			end
		end

		result = math.max(result, is_a_match)
		min_diff = math.min(diff, min_diff)

		if dbg_dmgs and result == 1 then
			local peer_dis_txt = peer_dis and (' pd=%.2fm'):format(peer_dis/100) or ''
			if category == 'fire' then
				table.insert(dbg_dmgs, {
					damage_percent,
					diff .. '~' .. math.ceil(self._HEALTH_GRANULARITY * (error_rate - 1)),
					is_a_match,
					_options:get_options_desc() .. peer_dis_txt
				})
			end
		end
	end

	local function walk_options(rank)
		if rank == 0 then
			local dmg_mul = 1
			if category == 'melee' then -- see PlayerStandard:_do_melee_damage()
				dmg_mul = dmg_mul * dmg_mul_berserker
				dmg_mul = dmg_mul * dmg_mul_overdog
				dmg_mul = dmg_mul * dmg_mul_bloodthirst
				dmg_mul = dmg_mul * managers_player:upgrade_value('player', pumping_iron_upgrade, 1)
				dmg_mul = dmg_mul * managers_player:upgrade_value('player', melee_weapon_type_damage_multiplier, 1)
				attack_data.damage = attack_data.base_melee_damage * dmg_mul

			elseif is_saw_tank then -- see SawHit:on_collision()
				attack_data.damage = 50

			elseif fire_dot then
				attack_data.damage = fire_dot.dot_damage

			else -- see PlayerStandard:_check_action_primary_attack()
				wbase:update_damage()
				dmg_mul = dmg_mul * dmg_mul_berserker
				dmg_mul = dmg_mul * managers_player:temporary_upgrade_value('temporary', 'dmg_multiplier_outnumbered', 1)
				dmg_mul = dmg_mul * managers_player:temporary_upgrade_value('temporary', 'overkill_damage_multiplier', 1)
				dmg_mul = dmg_mul * managers_player:get_property('trigger_happy', 1)
				attack_data.damage = wbase._damage * dmg_mul
			end

			local damage_percent = func_damage(self, attack_data)
			if is_shotgun then
				local col_ray = { distance = get_false_dis(dis) }
				attack_data.damage = NPCShotgunBase.get_damage_falloff(wbase, attack_data.damage, col_ray, attacker_unit, inc_range_mul > 1)
				local damage_percent_falloff = func_damage(self, attack_data)
				eval_result(damage_percent_falloff, damage_percent)
			else
				eval_result(damage_percent)
			end

			return
		end

		local option = _options.list[rank]
		option:reset()
		repeat
			walk_options(rank - 1)
		until not option:inc()
	end
	walk_options(#_options.list)

	local match_str = {
		'NOK', -- clearly out of bounds		> red
		'MEH', -- uninterpretable result	> grey
		'OK?', -- within error range		> green
		'OK!'  -- numbers are very happy	> lime
	}
	if result == 1 then
		log(('[NoMA] %s did %.1f damage (%s%s %s) with %s on %s (id %i) at %.2fm'):format(
			profile.name,
			damage_recv,
			death and 'deadly ' or '',
			fire_dot and 'fire dot' or category,
			match_str[result],
			data_holder.name,
			self._unit:base()._tweak_table,
			self._unit:id(),
			(dis > 0 and dis or mvector3.distance(self._unit:movement():m_pos(), attacker_unit:position())) / 100
		))
	end
	if dbg_dmgs and #dbg_dmgs > 0 then
		local dmg_details = ''
		table.sort(dbg_dmgs, function(a,b) return math.abs(b[1]) > math.abs(a[1]) end)
		for _, v in ipairs(dbg_dmgs) do
			if v[3] == result then
				dmg_details = dmg_details .. ('\n%i	%s	%s	%s'):format(
					v[1], v[2], match_str[ v[3] ], v[4])
			end
		end
	end

	-- undo hacky mess
	wbase._damage_near = nil
	wbase._damage_far = nil
	wbase._current_stats = original_current_stats
	wbase._name_id = original_weapon_id
	wbase._damage = original_damage
	managers_player._global.upgrades = original_player_upgrades
	managers_player._global._temporary_upgrades = original_player_temporary_upgrades
	managers_player._properties._properties = original_player_properties

	-- feed stats
	local function inc_counter(tbl, dmg)
		local dmg_rounded = math.round(dmg * 10) / 10
		tbl[dmg_rounded] = (tbl[dmg_rounded] or 0) + 1
	end

	local function inc_bonus_counter(tbl, opts_values)
		if #_options.snapshots > 0 then
			tbl.total = tbl.total + 1
			for i, option in ipairs(_options.list) do
				if opts_values[i] > 0 then
					tbl[option.name] = (tbl[option.name] or 0) + 1
				end
			end
		end
	end

	stats_holder.assessed_nr = stats_holder.assessed_nr + 1
	inc_counter(stats_holder.damage_all_counter, damage_recv)
	inc_counter(stats_holder.damage_eval_counter[result], damage_recv)
	stats_holder.eval_counter[result] = stats_holder.eval_counter[result] + 1
	local detected_upgrades, opts_values = _options:get_checkable_upgrades()
	inc_bonus_counter(stats_holder.bonus_eval_counter, opts_values)
	-- log(_options:get_options_desc(opts_values))

	if death and category == 'melee' then
		profile.melee.bloodthirst_mul_tracker = 1
	end

	-- check what's checkable
	for _, upgrade in ipairs(detected_upgrades) do
		if not profile.upgrades[upgrade] then
			NoMA:CheckUpgrade(peer, upgrade)
		end
	end

	local threshold = 0
	if category == 'melee' then
		threshold = 0.1
	elseif consider_berserker then
		threshold = 0.05
	end

	local nok_nr = stats_holder.eval_counter[1]
	if nok_nr < 10 then
		-- wait for it
	elseif nok_nr / stats_holder.assessed_nr < threshold then
		-- be nice with cases that may be affected by lag
	else
		local what = fire_dot and 'fire generated by' or 'his'
		local reason = ('%s %s has done impossible damages at least %i times'):format(what, data_holder.name, nok_nr)
		if not NoMA:MarkCheater(peer, reason) then
			if not stats_holder.cheated or nok_nr % 50 == 0 then
				NoMA:Tell(NoMA:GetCheaterMessage(peer, reason))
			end
		end
		stats_holder.cheated = true
	end
end
