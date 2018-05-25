Hooks:PreHook(ShotgunBase, "_fire_raycast", "change_bullet_class", function(self)
	if self._ammo_data and self._ammo_data.bullet_class and self._ammo_data.bullet_class_alt then
		if self._ammo_data.bullet_class_alt.fd == "wpn_fps_electricfirepoisonexplosivebullet" then
			--[[
			self._bullet_class_change = self._bullet_class_change or 0
			self._bullet_class_change = self._bullet_class_change + 1
			if self._bullet_class_change > #self._ammo_data.bullet_class_alt.class then
				self._bullet_class_change = 1
			end
			self._bullet_class = CoreSerialize.string_to_classtable(self._ammo_data.bullet_class_alt.class[self._bullet_class_change])
			]]
			self._bullet_class = CoreSerialize.string_to_classtable(self._ammo_data.bullet_class_alt.class[math.random(#self._ammo_data.bullet_class_alt.class)])
			self._bullet_slotmask = self._bullet_class:bullet_slotmask()
			self._blank_slotmask = self._bullet_class:blank_slotmask()
		end
	end
end)

Hooks:PostHook(ShotgunBase, "_update_stats_values", "add_bullet_class_alt", function(self)
	if self._ammo_data and self._ammo_data.bullet_class then
		local alt_ammo_data = managers.weapon_factory:get_ammo_data_from_weapon(self._factory_id, self._blueprint) or {}
		if alt_ammo_data and alt_ammo_data.bullet_class and alt_ammo_data.bullet_class_alt then
			self._ammo_data.bullet_class_alt = alt_ammo_data.bullet_class_alt
		end
	end
end)

local bullet_class_alt_PoisonBullet_on_collision = ProjectilesPoisonBulletBase.on_collision

function ProjectilesPoisonBulletBase:on_collision(col_ray, weapon_unit, ...)
	if weapon_unit.base and not weapon_unit:base()._projectile_entry and weapon_unit:base()._ammo_data and weapon_unit:base()._ammo_data.bullet_class and weapon_unit:base()._ammo_data.bullet_class_alt then
		if weapon_unit:base()._ammo_data.bullet_class_alt.fd == "wpn_fps_electricfirepoisonexplosivebullet" then
			weapon_unit:base()._projectile_entry = "wpn_prj_four"		
		end
	end
	return bullet_class_alt_PoisonBullet_on_collision(self, col_ray, weapon_unit, ...)
end

InstantElectricAltBulletBase = InstantElectricAltBulletBase or class(InstantBulletBase)

function InstantElectricAltBulletBase:give_impact_damage(col_ray, weapon_unit, user_unit, damage, armor_piercing)
	local defense_data = {}
	if weapon_unit.base and weapon_unit:base()._ammo_data and weapon_unit:base()._ammo_data.bullet_class and weapon_unit:base()._ammo_data.bullet_class_alt then
		if weapon_unit:base()._ammo_data.bullet_class_alt.fd == "wpn_fps_electricfirepoisonexplosivebullet" then
			local hit_unit = col_ray.unit
			local action_data = {}
			action_data.weapon_unit = weapon_unit
			action_data.attacker_unit = user_unit
			action_data.col_ray = col_ray
			action_data.armor_piercing = armor_piercing
			action_data.attacker_unit = user_unit
			action_data.attack_dir = col_ray.ray
			
			action_data.variant = "taser_tased"
			action_data.damage = damage
			action_data.damage_effect = 1
			action_data.name_id = "taser"
			action_data.charge_lerp_value = 0	
			
			defense_data = hit_unit and hit_unit:character_damage().damage_tase and hit_unit:character_damage():damage_melee(action_data)
			if hit_unit and hit_unit:character_damage().damage_tase then
				action_data.damage = 0
				action_data.damage_effect = nil
				hit_unit:character_damage():damage_tase(action_data)
			end
		end
	end
	return defense_data	
end