Hooks:PostHook(CopDamage, "damage_explosion", "F_"..Idstring("CopDamage:damage_explosion:wpn_fps_black_box_body"):key(), function(self, attack_data)
	if attack_data.weapon_unit and attack_data.attacker_unit == managers.player:player_unit() then
		local wep = attack_data.weapon_unit
		local ply = managers.player:player_unit()
		if wep:base() and wep:base()._is_black_box then
			ply:character_damage():restore_health(0.05)
		end
	end
end)