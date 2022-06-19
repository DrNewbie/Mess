local hook1 = _G.EEArmorBuffMain.__Name("sp_thorns::hook1")
local hook2 = _G.EEArmorBuffMain.__Name("sp_thorns::hook2")
local msgr1 = _G.EEArmorBuffMain.__Name("sp_thorns::msgr1")
local bool1 = _G.EEArmorBuffMain.__Name("sp_thorns::is_sp_thorns")

Hooks:PostHook(PlayerDamage, "init", hook1, function(self)
	managers.player:unregister_message(Message.OnPlayerDamage, msgr1)
	managers.player:register_message(Message.OnPlayerDamage, msgr1, function(attack_data)
		local sp_thorns_now = managers.player:__EE_Armor_Get_Var_by_Lv_and_ID(nil, 5)
		if type(sp_thorns_now) == "number" and sp_thorns_now > 0 and type(attack_data) == "table" and not attack_data[bool1] and attack_data.attacker_unit and alive(attack_data.attacker_unit) and attack_data.attacker_unit ~= self._unit then
			local attacker_unit = attack_data.attacker_unit
			if attacker_unit.character_damage and attacker_unit:character_damage() and attacker_unit:character_damage().damage_simple then
				local __r_damage = attack_data.damage and attack_data.damage * sp_thorns_now / 100 or 1
				__r_damage = math.max(__r_damage, 1)
				attack_data[bool1] = true
				attacker_unit:character_damage():damage_simple({
					variant = "bullet",
					damage = __r_damage,
					attacker_unit = self._unit,
					pos = attacker_unit:position(),
					attack_dir = attacker_unit:rotation():y()
				})
			end
		end
	end)
end)

Hooks:PreHook(PlayerDamage, "pre_destroy", hook2, function(self)
	managers.player:unregister_message(Message.OnPlayerDamage, msgr1)
end)