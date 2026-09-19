Hooks:PostHook(ProjectileWeaponBase, "update_next_shooting_time", "Pro_update_next_shooting_time", function(self)
	if self:is_single_shot() and self:is_category("grenade_launcher") and managers.player:has_activate_temporary_upgrade("temporary", "berserker_damage_multiplier") then
		local RoF = (tweak_data.weapon[self._name_id].fire_mode_data and tweak_data.weapon[self._name_id].fire_mode_data.fire_rate or 0) / self:fire_rate_multiplier()
		if RoF > 0 then
			RoF = RoF * 0.55
			self._next_fire_allowed = self._next_fire_allowed - RoF
			if ProjectileBase and ProjectileBase.time_cheat then
				local owner_peer_id = managers.network:session():local_peer():id()
				if owner_peer_id then
					local projectile_type = tweak_data.weapon[self._name_id].projectile_type
					if projectile_type then
						local projectile_type_index = tweak_data.blackmarket:get_index_from_projectile_id(projectile_type)
						if projectile_type_index > 0 then
							ProjectileBase.time_cheat[projectile_type_index][owner_peer_id] = ProjectileBase.time_cheat[projectile_type_index][owner_peer_id] - RoF
						end
					end
				end
			end
		end
	end
end)