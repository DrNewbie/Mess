local AltCopDamage_damage_bullet_00000000000000000001 = CopDamage.damage_bullet
function CopDamage:damage_bullet(attack_data, ...)
	local Ans = AltCopDamage_damage_bullet_00000000000000000001(self, attack_data, ...)
	if type(self._health_ratio) == "number" then
		local is_bool_armor_piercing = false
		if self._has_plate and attack_data.col_ray and attack_data.col_ray.body and attack_data.col_ray.body:name() == self._ids_plate_name and not attack_data.armor_piercing then
			if attack_data.attacker_unit == managers.player:player_unit() and not attack_data.weapon_unit:base().thrower_unit then
				if not managers.player:has_category_upgrade("player", "armor_piercing_chance") and 
					not managers.player:has_category_upgrade("weapon", "armor_piercing_chance") and 
					not managers.player:has_category_upgrade("weapon", "armor_piercing_chance_2") then
					is_bool_armor_piercing = true
				end
			end
		end
		if not Ans and is_bool_armor_piercing and math.random() > self._health_ratio - 0.07 then
			self._unit:movement():play_redirect("concussion_stun")
		end
	end
	return Ans
end