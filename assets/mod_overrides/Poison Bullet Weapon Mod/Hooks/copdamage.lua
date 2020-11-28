Hooks:PreHook(CopDamage, 'damage_bullet', 'F_'..Idstring('PreHook:CopDamage:damage_bullet:Poison Bullet (Weapon Mod)'):key(), function(self, attack_data)
	if self.damage_dot and attack_data and attack_data.damage and attack_data.col_ray and attack_data.attacker_unit and alive(attack_data.attacker_unit) and attack_data.attacker_unit == managers.player:player_unit() then
		local player = attack_data.attacker_unit
		if player and player == managers.player:local_player() and player:inventory() and player:inventory():equipped_unit():base():is_category("snp") then
			if table.contains(player:inventory():equipped_unit():base()._blueprint, "wpn_fps_ddlion_poison_bullet") then
				local __dot_length = 10 + math.random()*10
				local __dot_damage = 5 + math.random()*5
				PoisonBulletBase:give_damage_dot(attack_data.col_ray, player:inventory():equipped_unit(), player, __dot_length, true, "bow_poison_arrow")
				managers.dot:add_doted_enemy(self._unit, TimerManager:game():time(), player:inventory():equipped_unit(), __dot_length, __dot_damage, true, "poison", "bow_poison_arrow")
			end
		end
	end	
end)