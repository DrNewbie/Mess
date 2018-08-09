Hooks:PostHook(CopDamage, "damage_melee", "MeleeHitsoundPly_damage_melee_cop_event", function(self, attack_data)
	if attack_data.attacker_unit and attack_data.attacker_unit == managers.player:player_unit() then
		managers.player:player_unit():sound():_play("MeleeHitsound")
	end
end)