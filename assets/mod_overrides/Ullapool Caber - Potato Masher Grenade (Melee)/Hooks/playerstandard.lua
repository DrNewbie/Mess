local old_do_melee_damage = PlayerStandard._do_melee_damage

function PlayerStandard:_do_melee_damage(t, bayonet_melee, melee_hit_ray, melee_entry, ...)
	melee_entry = melee_entry or managers.blackmarket:equipped_melee_weapon()
	local col_ray = old_do_melee_damage(self, t, bayonet_melee, melee_hit_ray, melee_entry, ...)
	if melee_entry and melee_entry == "potato_masher_grenade" and col_ray then
		local shoot_pos = self._ext_movement:m_head_pos()
		local range = ConcussionGrenade._PLAYER_FLASH_RANGE * 2
		managers.explosion:play_sound_and_effects(shoot_pos, math.UP, range, {
			camera_shake_max_mul = 4,
			effect = "effects/particles/explosions/explosion_flash_grenade",
			sound_event = "concussion_explosion",
			feedback_range = range
		})
		managers.explosion:detect_and_stun({
			player_damage = 0,
			hit_pos = shoot_pos,
			range = range,
			collision_slotmask = managers.slot:get_mask("explosion_targets"),
			curve_pow = 3,
			damage = 0,
			ignore_unit = self._unit,
			alert_radius = range*2,
			user = self._unit,
			verify_callback = callback(ConcussionGrenade, ConcussionGrenade, "_can_stun_unit")
		})
		managers.explosion:detect_and_give_dmg({
			player_damage = 0,
			hit_pos = shoot_pos,
			range = range,
			collision_slotmask = managers.slot:get_mask("explosion_targets"),
			curve_pow = 3,
			damage = tweak_data.blackmarket.melee_weapons[melee_entry].stats.max_damage * 0.65,
			ignore_unit = self._unit,
			alert_radius = range*2,
			user = self._unit
		})
		local detonate_pos = shoot_pos + math.UP * 100
		local affected, line_of_sight, travel_dis, linear_dis = QuickFlashGrenade._chk_dazzle_local_player(managers.player:local_player():base(), detonate_pos, range)
		managers.environment_controller:set_concussion_grenade(detonate_pos, line_of_sight, travel_dis, linear_dis, tweak_data.character.concussion_multiplier)
		World:effect_manager():spawn({
			effect = Idstring("effects/particles/explosions/explosion_grenade"),
			position = shoot_pos,
			normal = self._unit:rotation():y()
		})
		local sound_source = SoundDevice:create_source("TripMineBase")
		sound_source:set_position(shoot_pos)
		sound_source:post_event("trip_mine_explode")
		managers.enemy:add_delayed_clbk("TrMiexpl", callback(TripMineBase, TripMineBase, "_dispose_of_sound", {
			sound_source = sound_source
		}), TimerManager:game():time() + 4)
		if self._ext_damage then
			self._ext_damage:_calc_health_damage({damage = 12, variant = "melee"})
			local sound_eff_mul = math.clamp(1 - (travel_dis or linear_dis) / range, 0.3, 1)
			self._ext_damage:on_concussion(sound_eff_mul)
		end
		local RJ_3115ef7f11db7941 = Vector3()
		mvector3.set(RJ_3115ef7f11db7941, self._ext_movement:m_pos())
		mvector3.set_z(RJ_3115ef7f11db7941, RJ_3115ef7f11db7941.z * 4 * 1.8)
		mvector3.set_x(RJ_3115ef7f11db7941, 0)
		mvector3.set_y(RJ_3115ef7f11db7941, 0)
		self._ext_movement:push(RJ_3115ef7f11db7941)
	end
	return col_ray
end