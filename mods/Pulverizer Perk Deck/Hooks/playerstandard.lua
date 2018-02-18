Hooks:PostHook(PlayerStandard, "_do_melee_damage", "pulverizer_melee_event", function(self, t, bayonet_melee, melee_hit_ray)
	if managers.player:has_category_upgrade("player", "passive_pulverizer_melee_event") then
		local player_unit = managers.player:player_unit()
		local melee_id = managers.blackmarket:equipped_melee_weapon()
		local melee_tweak = tweak_data.blackmarket.melee_weapons[melee_id]
		local col_ray
		local sphere_cast_radius = 20
		local instant_hit = melee_tweak.instant
		local melee_damage_delay = melee_tweak.melee_damage_delay or 0
		local charge_lerp_value = instant_hit and 0 or self:_get_melee_charge_lerp_value(t, melee_damage_delay)
		if melee_hit_ray then
			col_ray = melee_hit_ray ~= true and melee_hit_ray or nil
		else
			col_ray = self:_calc_melee_hit_ray(t, sphere_cast_radius)
		end
		if col_ray then
			if charge_lerp_value < 0.99 then
				InstantExplosiveBulletBase:on_collision(col_ray, player_unit:inventory()._available_selections[1].unit, player_unit, melee_tweak.min_damage and melee_tweak.min_damage*100 or 1, false)
			else
				local pos_boom = nil
				if col_ray.hit_position then
					pos_boom = col_ray.hit_position
				elseif col_ray.position then
					pos_boom = col_ray.position
				elseif col_ray.unit and alive(col_ray.unit) and col_ray.unit:character_damage() then
					pos_boom = col_ray.unit:position()
				end
				if pos_boom then
					local range = melee_tweak.range and melee_tweak.range * 4 or 500
					local damage = melee_tweak.max_damage and melee_tweak.max_damage*100 or 1
					managers.explosion:play_sound_and_effects(
						pos_boom,
						math.UP,
						1000,
						{
							sound_event = "grenade_explode",
							effect = "effects/payday2/particles/explosions/grenade_explosion",
							camera_shake_max_mul = 4,
							sound_muffle_effect = true,
							feedback_range = range
						}
					)
					managers.explosion:detect_and_give_dmg({
						curve_pow = 5,
						player_damage = 0,
						hit_pos = pos_boom,
						range = range,
						collision_slotmask = managers.slot:get_mask("explosion_targets"),
						damage = damage,
						no_raycast_check_characters = false
					})
				end
			end
		end
	end
	if managers.player:has_category_upgrade("player", "passive_pulverizer_reduce_melee_delay") then
		local _prec = managers.player:upgrade_value("player", "passive_pulverizer_reduce_melee_delay", 0)
		if _prec > 0 then
			local _melee_id = managers.blackmarket:equipped_melee_weapon()
			local _melee_tweak = tweak_data.blackmarket.melee_weapons[_melee_id]
			local _expire_t = _melee_tweak.expire_t or 0
			local _repeat_expire_t = _melee_tweak.repeat_expire_t or 0		
			local r_expire_t = _expire_t * _prec
			local r_repeat_expire_t = _repeat_expire_t * _prec
			if self._state_data.melee_expire_t then
				self._state_data.melee_expire_t = self._state_data.melee_expire_t - r_expire_t
			end
			if self._state_data.melee_repeat_expire_t then
				self._state_data.melee_repeat_expire_t = self._state_data.melee_repeat_expire_t - r_repeat_expire_t
			end
		end
	end
end)

local pulverizer_melee_charge_lerp_value = PlayerStandard._get_melee_charge_lerp_value

function PlayerStandard:_get_melee_charge_lerp_value(t, offset)
	if not managers.player:has_category_upgrade("player", "passive_pulverizer_reduce_melee_charge") then
		return pulverizer_melee_charge_lerp_value(self, t, offset)
	end
	offset = offset or 0
	local melee_entry = managers.blackmarket:equipped_melee_weapon()
	local max_charge_time = tweak_data.blackmarket.melee_weapons[melee_entry].stats.charge_time
	max_charge_time = max_charge_time * managers.player:upgrade_value("player", "passive_pulverizer_reduce_melee_charge", 1)
	if not self._state_data.melee_start_t then
		return 0
	end
	return math.clamp((t - self._state_data.melee_start_t) - offset, 0, max_charge_time) / max_charge_time
end