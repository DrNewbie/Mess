Hooks:PostHook(NewRaycastWeaponBase, "_update_stats_values", "F_"..Idstring("PostHook:NewRaycastWeaponBase:_update_stats_values:30mm Heavy Bullet (Weapon Mod)"):key(), function(self)
	if not self.__is_wpn_fps_sss_30mmmoballol_init and alive(self._unit) and self._unit:base()._blueprint and table.contains(self._unit:base()._blueprint, "wpn_fps_sss_30mmmoballol") then
		self.__is_wpn_fps_sss_30mmmoballol_init = true
		self.__is_wpn_fps_sss_30mmmoballol = true
	end
end)

Hooks:PostHook(NewRaycastWeaponBase, "_fire_raycast", "F_"..Idstring("PostHook:NewRaycastWeaponBase:_fire_raycast:30mm Heavy Bullet (Weapon Mod)"):key(), function(self, user_unit, from_pos, direction)
	if self.__is_wpn_fps_sss_30mmmoballol and managers.player:local_player() and user_unit and user_unit == managers.player:local_player() then
		local shoot_pos = from_pos + direction * 20
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
			ignore_unit = user_unit,
			alert_radius = range*2,
			user = user_unit,
			verify_callback = callback(ConcussionGrenade, ConcussionGrenade, "_can_stun_unit")
		})
		local detonate_pos = shoot_pos + math.UP * 100
		local affected, line_of_sight, travel_dis, linear_dis = QuickFlashGrenade._chk_dazzle_local_player(managers.player:local_player():base(), detonate_pos, range)
		managers.environment_controller:set_concussion_grenade(detonate_pos, line_of_sight, travel_dis, linear_dis, tweak_data.character.concussion_multiplier)
		local sound_eff_mul = math.clamp(1 - (travel_dis or linear_dis) / range, 0.3, 1)
		managers.player:player_unit():character_damage():on_concussion(sound_eff_mul)
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
	end
end)