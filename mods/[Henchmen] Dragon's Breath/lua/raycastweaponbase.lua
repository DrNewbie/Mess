local _FF_crew_flame_ammo = InstantBulletBase.on_collision
	
function InstantBulletBase:give_impact_damage(col_ray, weapon_unit, user_unit, damage, armor_piercing, shield_knock, knock_down, stagger, variant)
	local action_data = {}
	action_data.variant = variant or "bullet"
	action_data.damage = damage
	action_data.weapon_unit = weapon_unit
	action_data.attacker_unit = user_unit
	action_data.col_ray = col_ray
	action_data.armor_piercing = armor_piercing
	action_data.shield_knock = shield_knock
	action_data.origin = user_unit:position()
	action_data.knock_down = knock_down
	action_data.stagger = stagger
	for _, team_ai in pairs(managers.groupai:state():all_AI_criminals()) do
		if team_ai and team_ai.unit and team_ai.unit:movement() and team_ai.unit == user_unit and managers.player:has_category_upgrade("team", "crew_flame_ammo") then
			action_data.variant = "fire"
			action_data.fire_dot_data = {
				dot_damage = 25,
				dot_trigger_max_distance = 3000,
				dot_trigger_chance = 35,
				dot_length = 6.1,
				dot_tick_period = 0.5
			}
			break
		end
	end
	local defense_data = col_ray.unit:character_damage():damage_bullet(action_data)
	return defense_data
end