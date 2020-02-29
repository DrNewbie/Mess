local back_mvec_to = Vector3()

Hooks:PostHook(ProjectileWeaponBase, "_fire_raycast", "F_"..Idstring("PostHook:_fire_raycast:RPG BACK BLAST"):key(), function(self, user_unit, from_pos, direction, ...)
	local __projectile_type = self._projectile_type or tweak_data.blackmarket:get_projectile_name_from_index(2)
	if __projectile_type and __projectile_type == "rocket_frag" and InstantExplosiveBulletBase then
		mvector3.set(back_mvec_to, -direction)
		mvector3.multiply(back_mvec_to, 150)
		mvector3.add(back_mvec_to, from_pos)
		ProjectileBase._play_sound_and_effects(back_mvec_to, -direction, 100, CarryData.EXPLOSION_CUSTOM_PARAMS)
		local __units = World:find_units("sphere", back_mvec_to, 75,  managers.slot:get_mask("enemies", "civilians"))
		if __units then
			for _, __hit in pairs(__units) do
				if __hit:character_damage() and not __hit:character_damage():dead() and __hit:character_damage().damage_explosion then
					__hit:character_damage():damage_explosion({
						variant = "explosion",
						attacker_unit = user_unit,
						range = 10,
						damage = __hit:character_damage()._health * 0.25,
						col_ray = {
							position = __hit:position(),
							ray = math.UP
						}
					})
				end
			end
		end
	end
end)