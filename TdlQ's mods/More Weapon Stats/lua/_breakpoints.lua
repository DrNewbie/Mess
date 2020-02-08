BlackMarketGui.mws_alpha_unavailable = 0.1
BlackMarketGui.mws_alpha_disabled = 0.5
BlackMarketGui.mws_alpha_enabled = 1

BlackMarketGui.mws_unit_types = {
	'swat',
	'heavy_swat',
	'sniper',
	'taser',
	'spooc',
	'tank'
}

BlackMarketGui.mws_bonuses = {
	prison_wife    = { index = 1, required_level = 0, available = false, checked_by_default = true,  x = 0   }, -- used for headshot
	hitman         = { index = 2, required_level = 1, available = false, checked_by_default = false, x = 1.5 },
	underdog       = { index = 3, required_level = 1, available = false, checked_by_default = false, x = 2.5 },
	overkill       = { index = 4, required_level = 1, available = false, checked_by_default = false, x = 3.5 },
	body_expertise = { index = 5, required_level = 1, available = false, checked_by_default = true,  x = 4.5 },
	backstab       = { index = 6, required_level = 1, available = false, checked_by_default = true,  x = 5.5 },
	trigger_happy  = { index = 7, required_level = 1, available = false, checked_by_default = true,  x = 6.5 },
	wolverine      = { index = 8, required_level = 1, available = false, checked_by_default = true,  x = 7.5 }
}

function BlackMarketGui:mws_set_bonus_availability()
	local function _set_bonus_available(bonus)
		if bonus.available then
			if bonus.checked == nil then
				bonus.checked = bonus.checked_by_default
			end
		else
			bonus.checked = false
		end
	end

	for skill_name, bonus in pairs(self.mws_bonuses) do
		local skill_level = managers.skilltree._global.skills[skill_name].unlocked
		bonus.level = skill_level
		bonus.available = skill_level >= bonus.required_level
		_set_bonus_available(bonus)
	end
end

function BlackMarketGui:mws_get_breakpoints(unit_type, params)
	local result = {}
	local ct = tweak_data.character[unit_type]
	local _HEALTH_GRANULARITY = 512 -- CopDamage._HEALTH_GRANULARITY

	local health = ct.HEALTH_INIT
	if not health then
		return result
	end

	if managers.crime_spree:is_active() then
		local modifiers = managers.modifiers and managers.modifiers._modifiers
		if type(modifiers) ~= 'table' or type(modifiers.crime_spree) ~= 'table' or table.size(modifiers.crime_spree) == 0 then
			managers.crime_spree:_setup_modifiers()
		end
	end

	health = health * 10
	local _HEALTH_INIT_PRECENT = health / _HEALTH_GRANULARITY

	local damage_clamp
	if params.explosion then
		if managers.modifiers:modify_value('CopDamage:DamageExplosion', 123, unit_type) == 0 then
			return result
		end
		damage_clamp = ct.DAMAGE_CLAMP_EXPLOSION
	elseif params.fire then
		-- qued
	else
		damage_clamp = ct.DAMAGE_CLAMP_BULLET
	end

	local headshot_mul = 1
	if params.explosion then
		headshot_mul = ct.damage.explosion_damage_mul or 1

	elseif params.headshot then
		if not ct.ignore_headshot then
			local headshot_dmg_mul = ct.headshot_dmg_mul or 1
			headshot_mul = managers.player:upgrade_value('weapon', 'passive_headshot_damage_multiplier', 1) * headshot_dmg_mul
		end

	elseif params.body_expertise then
		if ct.tags and table.contains(ct.tags, 'tank') then
			-- qued
		else
			local headshot_dmg_mul = managers.player:upgrade_value('weapon', 'automatic_head_shot_add', nil)
			if headshot_dmg_mul then
				headshot_mul = 1 + headshot_dmg_mul * math.max(0, (ct.headshot_dmg_mul or 1) - 1)
			end
		end
	end

	local crit_mul = 0
	local crit_chance = 0
	if params.crits then
		local crits = ct.critical_hits or {}
		crit_chance = (crits.base_chance or 0) + managers.player:critical_hit_chance() * (crits.player_chance_multiplier or 1)
		if crit_chance > 0 then
			crit_mul = crits.damage_mul or ct.headshot_dmg_mul
			if not crit_mul then
				crit_chance = 0
			end
		end
	end

	local hitman_mul = 1
	if ct.tags and table.contains(ct.tags, 'special') then
		if params.hitman >= 1 then
			hitman_mul = tweak_data.upgrades.values.player.marked_enemy_damage_mul
		end
		if params.hitman >= 2 then
			hitman_mul = hitman_mul * tweak_data.upgrades.values.player.marked_inc_dmg_distance[1][2]
		end
	end

	local underdog_mul = params.underdog and tweak_data.upgrades.values.temporary.dmg_multiplier_outnumbered[1][1] or 1

	local overkill_mul = params.overkill and tweak_data.upgrades.values.temporary.overkill_damage_multiplier[1][1] or 1

	local berserker_mul = 1
	if params.berserker then
		local health_ratio = tweak_data.player.damage.REVIVE_HEALTH_STEPS[1] * managers.player:upgrade_value('player', 'revived_health_regain', 1)
		local categories = wbase:categories()
		local primary_category = categories and categories[1]
		local damage_health_ratio = managers.player:get_damage_health_ratio(health_ratio, primary_category)
		berserker_mul = 1 + managers.player:upgrade_value('player', params.berserker, 0) * damage_health_ratio
	end


	local th_mul, th_nr
	if params.trigger_happy then
		local td = tweak_data.upgrades.values.pistol.stacking_hit_damage_multiplier[params.trigger_happy]
		th_mul = td.damage_bonus
		th_nr = math.floor(td.max_time / params.shoot_interval)
	end

	local all_mul = headshot_mul * hitman_mul * underdog_mul * overkill_mul * berserker_mul

	local previous_bp
	for i = 1, _HEALTH_GRANULARITY do
		local crit_nr = math.ceil(i * crit_chance)

		local final_i = i
		if th_mul then
			local th_initiator_nr
			if MoreWeaponStats.settings.enable_trigger_happy_for_first_bullet then
				th_initiator_nr = math.floor(i / (1 + th_nr))
			else
				th_initiator_nr = math.ceil(i / (1 + th_nr))
			end
			local th_boosted_nr = math.max(0, i - th_initiator_nr)
			final_i = final_i + th_boosted_nr * (th_mul - 1) * math.max(1, (crit_mul - 1) * crit_nr) -- yeah, crits ignore initiators...
		elseif crit_nr > 0 then
			final_i = final_i + (crit_mul - 1) * crit_nr
		end

		local dmg = health / final_i
		local bp = math.ceil(math.clamp(dmg / _HEALTH_INIT_PRECENT, 1, _HEALTH_GRANULARITY)) * _HEALTH_INIT_PRECENT

		if final_i == i then
			bp = bp - _HEALTH_INIT_PRECENT
		end

		bp = bp / all_mul
		if previous_bp == bp then
		elseif damage_clamp and bp > damage_clamp then
			break
		else
			if i > 1 and bp < 10 then
				break
			end
			result[i] = math.ceil(bp * 100) / 100
		end

		previous_bp = bp
	end

	return result
end

function BlackMarketGui:mws_get_all_breakpoints(params)
	local result = {}
	for _, unit_type in ipairs(self.mws_unit_types) do
		result[unit_type] = self:mws_get_breakpoints(unit_type, params)
	end
	return result
end

local function mws_equipped_selected()
	local slot_data = MoreWeaponStats.mws_slot_data
	if slot_data then
		local result = managers.blackmarket:get_crafted_category_slot(slot_data.category, slot_data.slot)
		if result then
			return result
		end

		local factory_id = managers.weapon_factory:get_factory_id_by_weapon_id(slot_data.name)
		return {
			equipped = true,
			factory_id = factory_id,
			blueprint = deep_clone(managers.weapon_factory:get_default_blueprint_by_factory_id(factory_id)),
			weapon_id = slot_data.name,
			global_values = {}
		}
	end
end

local function mws_can_be_critical(weapon_unit_base, damage_type) -- see CopDamage:can_be_critical()
	if weapon_unit_base == nil then
		return true
	end
	local weapon_type = nil
	if weapon_unit_base.thrower_unit then
		local unit_base = weapon_unit_base._unit:base()
		if unit_base._tweak_projectile_entry then
			weapon_type = unit_base._tweak_projectile_entry
		elseif unit_base._projectile_entry then
			weapon_type = unit_base._projectile_entry
		end
	elseif weapon_unit_base.weapon_tweak_data then
		local weapon_td = weapon_unit_base:weapon_tweak_data()
		weapon_type = weapon_td.categories[1]
	elseif weapon_unit_base.get_name_id then
		weapon_type = weapon_unit_base:get_name_id()
	end
	local damage_crit_data = tweak_data.weapon_disable_crit_for_damage[weapon_type]
	if not damage_crit_data then
		return true
	end
	local is_damage_type_can_crit = damage_crit_data[damage_type]
	if is_damage_type_can_crit then
		return true
	end
	return false
end

function BlackMarketGui:mws_prepare_breakpoints_params(wbase)
	local ammo_type = wbase._ammo_data and wbase._ammo_data.bullet_class
	local explosion = ammo_type == 'InstantExplosiveBulletBase'
	local fire = ammo_type == 'FlameBulletBase' or wbase:is_category('flamethrower')
	local damage_type = explosion and 'explosion' or fire and 'fire' or 'bullet'

	local can_full_auto = wbase._fire_mode_category == 'auto' or wbase:can_toggle_firemode()
	local shoot_interval = wbase._next_fire_allowed
	if not can_full_auto then
		local is_akimbo = wbase:is_category('akimbo')
		local manual_rate_modifier = is_akimbo and 2 or 1 -- 1 click but 2 bullets
		shoot_interval = math.max(shoot_interval, 1 / (manual_rate_modifier * MoreWeaponStats.settings.clicks_per_second))
	end

	local bonuses = self.mws_bonuses
	local berserker = bonuses.wolverine.checked and (wbase:is_category('saw') and 'melee_damage_health_ratio_multiplier' or 'damage_health_ratio_multiplier')
	local bemul = wbase.get_add_head_shot_mul and wbase:get_add_head_shot_mul()
	local body_expertise = bonuses.body_expertise.checked and bemul and bemul > 0
	local crits = bonuses.backstab.checked and mws_can_be_critical(wbase, damage_type)
	local overkill = bonuses.overkill.checked and (bonuses.overkill.level == 2 or wbase:is_category('shotgun'))
	local trigger_happy = bonuses.trigger_happy.checked and wbase:is_category('pistol')

	local params = {
		explosion = explosion,
		fire = fire,
		headshot = bonuses.prison_wife.checked,
		hitman = bonuses.hitman.checked and bonuses.hitman.level or 0,
		underdog = bonuses.underdog.checked,
		overkill = overkill,
		body_expertise = body_expertise,
		crits = crits,
		trigger_happy = trigger_happy and bonuses.trigger_happy.level,
		berserker = berserker,
		shoot_interval = shoot_interval
	}

	if explosion then
		params.headshot = false
		params.hitman = math.min(1, params.hitman)
	elseif fire then
		params.headshot = false
		params.hitman = 0
	end

	return params
end

function BlackMarketGui:mws_consolidate_breakpoints(data, damage, amount_wanted)
	local all_bp = {}
	local ref_bp = -1
	for unit_type, bps in pairs(data) do
		for hit_nr, value in pairs(bps) do
			if value <= damage and value > ref_bp then
				ref_bp = value
			end

			local bp = all_bp[value]
			if not bp then
				bp = {
					value = value,
					hits_nr = {},
					herited_hits_nr = {}
				}
				all_bp[value] = bp
			end
			bp.hits_nr[unit_type] = hit_nr
		end
	end

	local tmp = {}
	local nr = 0
	for _, bp in pairs(all_bp) do
		nr = nr + 1
		tmp[nr] = bp
	end
	all_bp = tmp
	table.sort(all_bp, function (a, b)
		return a.value < b.value
	end)

	if MoreWeaponStats.settings.fill_breakpoints then
		local ut = self.mws_unit_types
		local last_hit_nr = {}
		for i = 1, nr do
			local bp = all_bp[i]
			for _, unit_type in pairs(ut) do
				local hit_nr = bp.hits_nr[unit_type]
				if hit_nr then
					last_hit_nr[unit_type] = hit_nr
				else
					bp.herited_hits_nr[unit_type] = last_hit_nr[unit_type]
				end
			end
		end
	end

	if all_bp[1].value >= 20 then
		while all_bp[1] and all_bp[1].value < 20 do
			table.remove(all_bp, 1)
			nr = nr - 1
		end
	end

	local result
	if amount_wanted >= nr then
		result = all_bp
	else
		result = {}
		for i = 1, nr do
			local bp = all_bp[i]
			if bp.value == ref_bp then
				local to_add = amount_wanted - 1
				local half_m = (to_add - (to_add % 2)) / 2
				local half_p = half_m + (to_add % 2)

				if half_m >= i then
					local diff = half_m - i + 1
					half_p = half_p + diff
					half_m = half_m - diff
				end

				if half_p > nr - i then
					local diff = half_p - (nr - i)
					half_p = half_p - diff
					half_m = half_m + diff
				end

				local nr2 = 1
				for j = i - half_m, i + half_p do
					result[nr2] = all_bp[j]
					nr2 = nr2 + 1
				end
				break
			end
		end
	end

	return ref_bp, result
end

function BlackMarketGui:mws_update_breakpoints()
	local changed = Faker:use_game_classes()
	pcall(function()
		self:_mws_update_breakpoints()
	end)
	if changed then
		Faker:use_normal_classes()
	end
end

function BlackMarketGui:_mws_update_breakpoints()
	if not self._slot_data then
		return
	elseif self._slot_data.empty_slot or not self._slot_data.unlocked then
		self.mws_bp_panel:hide()
	else
		self.mws_bp_panel:show()
	end

	local wbase = self:mws_get_wbase_from_slot(false)
	if not wbase then
		return
	end

	local original_primary = BlackMarketManager.equipped_primary
	local original_secondary = BlackMarketManager.equipped_secondary
	if self._slot_data.category == 'primaries' then
		BlackMarketManager.equipped_primary = mws_equipped_selected
	elseif self._slot_data.category == 'secondaries' then
		BlackMarketManager.equipped_secondary = mws_equipped_selected
	end

	local params = self:mws_prepare_breakpoints_params(wbase)
	local breakpoints_data = self:mws_get_all_breakpoints(params)

	self.mws_bp_current_damage = wbase._damage * 10
	self.mws_bp_ref_damage, self.mws_breakpoints = self:mws_consolidate_breakpoints(breakpoints_data, self.mws_bp_current_damage, #self.mws_bp_damage)

	BlackMarketManager.equipped_primary = original_primary
	BlackMarketManager.equipped_secondary = original_secondary

	for _, cell_dmg in pairs(self.mws_bp_bullet) do
		cell_dmg:set_text('-')
		cell_dmg:set_color(Color.white:with_alpha(0.5))
	end

	local ut = self.mws_unit_types
	for i, cell_dmg in pairs(self.mws_bp_damage) do
		local bp = self.mws_breakpoints[i]
		if bp then
			cell_dmg:set_text(('%0.2f'):format(bp.value))
			cell_dmg:set_color(bp.value == self.mws_bp_ref_damage and Color.yellow or Color.white:with_alpha(0.5))
			for _, unit_type in pairs(ut) do
				local cell_data = self.mws_bp_panel:child('mws_bp_bullet_' .. i .. '_' .. unit_type)
				local hit_nr = bp.hits_nr[unit_type]
				local color = bp.value == self.mws_bp_ref_damage and Color.yellow or Color.white
				if not hit_nr then
					color = color:with_alpha(0.5)
					hit_nr = bp.herited_hits_nr[unit_type] or '-'
				end
				cell_data:set_color(color)
				cell_data:set_text(hit_nr)
			end
		else
			cell_dmg:set_text('-')
			cell_dmg:set_color(Color.white:with_alpha(0.5))
		end
	end
end

function BlackMarketGui:mws_update_difficulty(difficulty, can_switch)
	local difficulty_id
	if managers.network:session() then
		difficulty = Global.game_settings.difficulty
		difficulty_id = tweak_data:difficulty_to_index(difficulty)
	else
		local current_id = tweak_data:difficulty_to_index(Global.game_settings.difficulty)
		difficulty_id = tweak_data:difficulty_to_index(difficulty)
		if can_switch and difficulty_id == current_id then
			difficulty_id = difficulty_id - 1
			difficulty = tweak_data:index_to_difficulty(difficulty_id)
		end
		Global.game_settings.difficulty = difficulty
		tweak_data.character:init(tweak_data)
		tweak_data.player:init(tweak_data)
		tweak_data.player['_set_' .. difficulty](tweak_data.player)
		tweak_data.character['_set_' .. difficulty](tweak_data.character)
	end
	MoreWeaponStats.settings.last_used_difficulty = difficulty

	local can_set_difficulty = not managers.network:session()
	for i, bmp in pairs(self.mws_bp_difficulty_bitmap) do
		local active = i < difficulty_id
		bmp:set_alpha(active and (can_set_difficulty and 1 or 0.5) or 0.25)
		bmp:set_color(active and tweak_data.screen_colors.risk or Color.white)
	end

	return can_set_difficulty
end

function BlackMarketGui:mws_bp_find_bonus_bmp_by_name(bonus_name)
	for _, bmp in pairs(self.mws_bp_skill_bitmaps) do
		if bmp:name() == bonus_name then
			return bmp
		end
	end
end

function BlackMarketGui:mws_bp_set_bonus_state(bmp, state)
	if type(bmp) == 'string' then
		bmp = self:mws_bp_find_bonus_bmp_by_name(bmp)
		if not bmp then
			return
		end
	end

	bmp:set_alpha(state and self.mws_alpha_enabled or self.mws_alpha_disabled)
	self.mws_bonuses[bmp:name()].checked = state
end

function BlackMarketGui:mws_bp_click_on_bonus(bmp)
	local state = bmp:alpha() ~= self.mws_alpha_enabled
	self:mws_bp_set_bonus_state(bmp, state)
end

local mws_original_blackmarketgui_mousepressed = BlackMarketGui.mouse_pressed
function BlackMarketGui:mouse_pressed(button, x, y)
	if self._enabled and not self._renaming_item and button == Idstring('0') then
		if self.mws_breakpoints then
			if self.mws_bp_panel:inside(x, y) then
				for i, bmp in pairs(self.mws_bp_difficulty_bitmap) do
					if bmp:inside(x, y) then
						if self:mws_update_difficulty(tweak_data:index_to_difficulty(i + 1), true) then
							self:mws_update_breakpoints()
						end
						break
					end
				end
				for i, bmp in pairs(self.mws_bp_skill_bitmaps) do
					if self.mws_bonuses[bmp:name()].available and bmp:inside(x, y) then
						self:mws_bp_click_on_bonus(bmp)
						self:mws_update_breakpoints()
						break
					end
				end
			end
		elseif self.mws_stances_panel then
			if self.mws_stances_panel:inside(x, y) then
				if self.mws_stances_bitmaps[1]:inside(x, y) then
					self.mws_in_steelsight = not self.mws_in_steelsight
					self.mws_stances_bitmaps[1]:set_visible(not self.mws_in_steelsight)
					self.mws_stances_bitmaps[2]:set_visible(self.mws_in_steelsight)
					self:show_stats()
				elseif self.mws_stances_bitmaps[3]:inside(x, y) then
					self.mws_ducking = not self.mws_ducking
					self.mws_stances_bitmaps[3]:set_visible(not self.mws_ducking)
					self.mws_stances_bitmaps[4]:set_visible(self.mws_ducking)
					self:show_stats()
				end
			end
		end
	end

	return mws_original_blackmarketgui_mousepressed(self, button, x, y)
end

local mws_original_blackmarketgui_mousemoved = BlackMarketGui.mouse_moved
function BlackMarketGui:mouse_moved(o, x, y)
	if self._enabled and not self._renaming_item then
		if self.mws_breakpoints then
			if self.mws_bp_panel:inside(x, y) then
				if not managers.network:session() then
					for i, bmp in pairs(self.mws_bp_difficulty_bitmap) do
						if bmp:inside(x, y) then
							return true, 'link'
						end
					end
				end
				for i, bmp in pairs(self.mws_bp_skill_bitmaps) do
					if self.mws_bonuses[bmp:name()].available and bmp:inside(x, y) then
						return true, 'link'
					end
				end
			end
		elseif self.mws_stances_panel then
			if self.mws_stances_panel:inside(x, y) then
				if self.mws_stances_bitmaps[1]:inside(x, y) or self.mws_stances_bitmaps[3]:inside(x, y) then
					return true, 'link'
				end
			end
		end
	end

	return mws_original_blackmarketgui_mousemoved(self, o, x, y)
end
