GrazeNoDMG2Me = GrazeNoDMG2Me or CivilianDamage.damage_simple

function CivilianDamage:damage_simple(attack_data, ...)
	if type(attack_data) == "talbe" and attack_data.variant and attack_data.variant == "graze" then
		return
	end
	return GrazeNoDMG2Me(self, attack_data, ...)
end