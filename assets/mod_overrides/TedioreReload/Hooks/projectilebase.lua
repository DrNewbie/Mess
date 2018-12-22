if (Net and Net:IsHost()) or (Global.game_settings and Global.game_settings.single_player) then
	function ProjectileBase:ThrowAndReloadBoom()	
		managers.explosion:play_sound_and_effects(
			self._throw_and_reload:position(),
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
			hit_pos = self._throw_and_reload:position(),
			range = 1000,
			collision_slotmask = managers.slot:get_mask("explosion_targets"),
			damage = self._throw_and_reload_dmg or 10,
			no_raycast_check_characters = false
		})
		World:delete_unit(self._throw_and_reload)
		self._throw_and_reload = nil
		self._throw_and_reload_dt = nil
		self._throw_and_reload_dmg = nil

	end

	Hooks:PostHook(ProjectileBase, "clbk_impact", "ThrowAndReloadBoomByImpact", function(self)
		if self._throw_and_reload and self._throw_and_reload_dt then
			self._throw_and_reload_dt = nil
			self:ThrowAndReloadBoom()
		end
	end)

	Hooks:PostHook(ProjectileBase, "update", "ThrowAndReloadBoomByTime", function(self, unit, t, dt)
		if self._throw_and_reload and self._throw_and_reload_dt then
			if self._throw_and_reload_dt then
				self._throw_and_reload_dt = self._throw_and_reload_dt - dt
				if self._throw_and_reload_dt <= 0 then
					self._throw_and_reload_dt = nil
					self:ThrowAndReloadBoom()
				end
			end
		end
	end)
end