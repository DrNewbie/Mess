local __old_damage_melee = CopDamage.damage_melee

function CopDamage:damage_melee(attack_data, ...)
	if type(attack_data) == "table" and not attack_data.__no_headShot_melee then
		attack_data.__no_headShot_melee = true
		local head = self._head_body_name and attack_data.col_ray.body and attack_data.col_ray.body:name() == self._ids_head_body_name
		if head then		
			self:damage_melee(attack_data)
		end
	end
	return __old_damage_melee(self, attack_data, ...)
end