local old_damage_fire = CopDamage.damage_fire

function CopDamage:damage_fire(attack_data, ...)
	local __attack_data = attack_data
	if type(__attack_data.fire_dot_data) == "table" and not __attack_data.fire_dot_data.__is_molten_2xfire and __attack_data.attacker_unit and managers.player:player_unit() and __attack_data.attacker_unit == managers.player:player_unit() and managers.player:Is_Glove_Molten() then
		__attack_data.fire_dot_data.__is_molten_2xfire = true
		__attack_data.fire_dot_data.dot_damage = __attack_data.fire_dot_data.dot_damage or 1
		__attack_data.fire_dot_data.dot_damage = __attack_data.fire_dot_data.dot_damage * 2
		__attack_data.fire_dot_data.dot_length = __attack_data.fire_dot_data.dot_length or 1
		__attack_data.fire_dot_data.dot_length = __attack_data.fire_dot_data.dot_length * 2		
	end
	return old_damage_fire(self, __attack_data, ...)
end