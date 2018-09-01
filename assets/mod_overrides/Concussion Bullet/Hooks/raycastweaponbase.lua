InstantConcussionBulletBase = InstantConcussionBulletBase or class(InstantBulletBase)

function InstantConcussionBulletBase:on_collision(col_ray, weapon_unit, user_unit, damage)
	if type(col_ray) == "table" and col_ray.unit then		
		local hit_unit = col_ray.unit
		if hit_unit:character_damage() and hit_unit:character_damage().stun_hit then
			hit_unit:character_damage():stun_hit({
				variant = "stun",
				damage = 0,
				attacker_unit = user_unit,
				weapon_unit = weapon_unit,
				col_ray = col_ray or {
					position = hit_unit:position(),
					ray = Vector3(0, 0, 1)
				}
			})
			if hit_unit:character_damage().damage_simple then
				hit_unit:character_damage():damage_simple({
					variant = "graze",
					damage = damage,
					attacker_unit = user_unit,
					pos = hit_unit:position(),
					attack_dir = Vector3(0, 0, 1)
				})
			end
			if true then
				local detonate_pos = hit_unit:position() + math.UP * 100
				local range = ConcussionGrenade._PLAYER_FLASH_RANGE
				local affected, line_of_sight, travel_dis, linear_dis = QuickFlashGrenade._chk_dazzle_local_player(self, detonate_pos, range)
				managers.explosion:play_sound_and_effects(detonate_pos, math.UP, range, {
					camera_shake_max_mul = 4,
					effect = "effects/particles/explosions/explosion_flash_grenade",
					sound_event = "concussion_explosion",
					feedback_range = range * 2
				})
				if affected then
					managers.environment_controller:set_concussion_grenade(detonate_pos, line_of_sight, travel_dis, linear_dis, tweak_data.character.concussion_multiplier)
					local sound_eff_mul = math.clamp(1 - (travel_dis or linear_dis) / range, 0.3, 1)
					managers.player:player_unit():character_damage():on_concussion(sound_eff_mul)
				end
			end
		end
	end
end