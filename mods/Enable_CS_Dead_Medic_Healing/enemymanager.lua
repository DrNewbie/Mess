Hooks:PostHook(EnemyManager, "on_enemy_died", 'F_'..Idstring("PostHook:EnemyManager:on_enemy_died:Enable CS Dead Medic Healing"):key(), function(self, dead_unit)
	if Network:is_client() then
	
	else
		if dead_unit:base():has_tag("medic") then
			local enemies = World:find_units_quick(dead_unit, "sphere", dead_unit:position(), tweak_data.medic.radius, managers.slot:get_mask("enemies"))
			for _, enemy in pairs(enemies) do
				if enemy and enemy:movement() and dead_unit:character_damage():heal_unit(enemy, true) then
					enemy:movement():action_request({
						body_part = 3,
						type = "healed",
						client_interrupt = false
					})
				end
			end
		end
	end
end)