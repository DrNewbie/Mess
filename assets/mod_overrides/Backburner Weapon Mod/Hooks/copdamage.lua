BackBurnerFunc = BackBurnerFunc or CopDamage.roll_critical_hit

function CopDamage:roll_critical_hit(attack_data, ...)
	if attack_data.damage and attack_data.variant and attack_data.variant == "fire" and attack_data.attacker_unit and attack_data.attacker_unit == managers.player:player_unit() and attack_data.weapon_unit then
		if attack_data.weapon_unit.base and attack_data.weapon_unit:base()._is_backburner then
			local damage = attack_data.damage
			local mvec3_dot = mvector3.dot			
			local hit_dir = self._unit:position() - attack_data.attacker_unit:position()
			local from_behind = mvec3_dot(hit_dir, self._unit:rotation():y()) >= 0
			if from_behind then
				damage =  damage * self._char_tweak.headshot_dmg_mul * 1.5
				return true, damage
			end
		end
	end
	return BackBurnerFunc(self, attack_data, ...)
end