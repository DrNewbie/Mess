InstantElectricBulletBase = InstantElectricBulletBase or class(InstantBulletBase)

function InstantElectricBulletBase:give_impact_damage(col_ray, weapon_unit, user_unit, damage, armor_piercing)
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
	
	local defense_data = hit_unit and hit_unit:character_damage().damage_tase and hit_unit:character_damage():damage_melee(action_data)
	if hit_unit and hit_unit:character_damage().damage_tase then
		action_data.damage = 0
		action_data.damage_effect = nil
		hit_unit:character_damage():damage_tase(action_data)
	end
	return defense_data
end