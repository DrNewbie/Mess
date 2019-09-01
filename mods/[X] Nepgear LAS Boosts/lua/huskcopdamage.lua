local old_husk_damage_melee = HuskCopDamage.damage_melee

function HuskCopDamage:damage_melee(attack_data, ...)
	attack_data = CopDamage.NepgearLASMeleeDmgBoost(self, attack_data)
	return old_husk_damage_melee(self, attack_data, ...)
end