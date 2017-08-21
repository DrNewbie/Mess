local _KnockBulldozer_CopDamagedamage_melee = CopDamage.damage_melee

function CopDamage:damage_melee(attack_data)
	if attack_data.shield_knock and self._unit:base()._tweak_table == "tank" then
		self._char_tweak.damage.shield_knocked = true
		attack_data.damage = math.clamp(attack_data.damage/10, 1, 10)
	end
	return _KnockBulldozer_CopDamagedamage_melee(self, attack_data)
end