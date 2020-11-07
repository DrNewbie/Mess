Hooks:PreHook(CopDamage, "damage_fire", "F_"..Idstring("BackBurnerFunc_damage_fire"):key(), function(self, attack_data)
	if not attack_data.__backburner_bonus and attack_data.weapon_unit and attack_data.weapon_unit.base and attack_data.weapon_unit:base()._is_backburner then
		local mvec3_dot = mvector3.dot			
		local hit_dir = self._unit:position() - attack_data.attacker_unit:position()
		local from_behind = mvec3_dot(hit_dir, self._unit:rotation():y()) >= 0
		if from_behind then
			local critical_hits = self._char_tweak.critical_hits or {}
			local critical_damage_mul = critical_hits.damage_mul or 1.5
			attack_data.damage = attack_data.damage * critical_damage_mul
			attack_data.__backburner_bonus = true
			managers.hud:on_crit_confirmed()
		end
	end
end)