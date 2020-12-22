local hook1 = 'F_'..Idstring('CopDamage:roll_critical_hit:Expanding Bullet (Weapon Mod)'):key()

CopDamage[hook1] = CopDamage[hook1] or CopDamage.roll_critical_hit

function CopDamage:roll_critical_hit(attack_data, ...)
	local critical_hit, damage = self[hook1](self, attack_data, ...)
	if not critical_hit and type(attack_data) == "table" and attack_data.variant and attack_data.variant == "bullet" and attack_data.damage and attack_data.col_ray and attack_data.attacker_unit and attack_data.weapon_unit and alive(attack_data.attacker_unit) and attack_data.attacker_unit == managers.player:player_unit() then
		if attack_data.weapon_unit:base():is_category("snp") and attack_data.weapon_unit:base().__wpn_fps_dd_expanding_bullet then
			critical_hit = true
			local critical_hits = self._char_tweak.critical_hits or {}
			local critical_damage_mul = critical_hits.damage_mul or self._char_tweak.headshot_dmg_mul
			if critical_damage_mul then
				damage = damage * critical_damage_mul
			else
				damage = self._health * 10
			end
		end
	end	
	return critical_hit, damage
end