local __old_cop_damage_bullet = CopDamage.damage_bullet

function CopDamage:damage_bullet(attack_data, ...)
	if attack_data and attack_data.damage and attack_data.attacker_unit and alive(attack_data.attacker_unit) and attack_data.attacker_unit == managers.player:player_unit() then
		local player = attack_data.attacker_unit
		if player and player == managers.player:local_player() and player:inventory() and player:inventory():equipped_unit():base():is_category("snp") then
			if table.contains(player:inventory():equipped_unit():base()._blueprint, "wpn_fps_ddlion_so_close_so_far") then
				local __ss_distance = mvector3.distance(self._unit:position(), player:position())
				local dis_buff = (__ss_distance/100) * 0.03 + 1
				attack_data.damage = attack_data.damage * dis_buff
			end
		end
	end	
	return __old_cop_damage_bullet(self, attack_data, ...)
end