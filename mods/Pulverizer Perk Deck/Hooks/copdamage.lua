local pulverizer_damage_melee = CopDamage.damage_melee
function CopDamage:damage_melee(attack_data)
	local is_ply = attack_data.attacker_unit and alive(attack_data.attacker_unit) and attack_data.attacker_unit == managers.player:player_unit() and managers.player:player_unit():character_damage() or nil
	local _prec = managers.player:upgrade_value("player", "passive_pulverizer_damage_stack", 0)
	if is_ply and _prec and attack_data and attack_data.damage then
		if TimerManager:game():time() > is_ply._pulverizer_damage_stack_t then
			is_ply._pulverizer_damage_stack_s = 0
		end
		local _d_prec = math.clamp(1 + is_ply._pulverizer_damage_stack_s, 1, 25)
		attack_data.damage = attack_data.damage * _d_prec
		is_ply._pulverizer_damage_stack_s = math.clamp(is_ply._pulverizer_damage_stack_s + _prec, 0, 24)
		is_ply._pulverizer_damage_stack_t = TimerManager:game():time() + 10
	end
	local res = pulverizer_damage_melee(self, attack_data)
	if is_ply and _prec and res and res.type == "death" then
		is_ply._pulverizer_damage_stack_s = math.clamp(is_ply._pulverizer_damage_stack_s + _prec*4, 0, 24)
	end
	return res
end