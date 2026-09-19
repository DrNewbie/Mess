Hooks:PostHook(TankCopDamage, "damage_melee", "F_"..Idstring("gets you insta incapacitated when you melee him.TankCopDamage.damage_melee"):key(), function(self, attack_data)
	if attack_data.attacker_unit and attack_data.attacker_unit == managers.player:player_unit() then
		managers.player:set_player_state("incapacitated")
	end
end)