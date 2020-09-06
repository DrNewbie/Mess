Hooks:PostHook(CopBrain, "convert_to_criminal", "F_"..Idstring("CopBrain:convert_to_criminal"):key(), function(self, mastermind_criminal)
	local damage_multiplier = 1
	if alive(mastermind_criminal) then
		damage_multiplier = damage_multiplier * (mastermind_criminal:base():upgrade_value("player", "convert_enemies_damage_multiplier") or 1)
		damage_multiplier = damage_multiplier * (mastermind_criminal:base():upgrade_value("player", "passive_convert_enemies_damage_multiplier") or 1)
	else
		damage_multiplier = damage_multiplier * managers.player:upgrade_value("player", "convert_enemies_damage_multiplier", 1)
		damage_multiplier = damage_multiplier * managers.player:upgrade_value("player", "passive_convert_enemies_damage_multiplier", 1)
	end
	local new_weapon_ids = tweak_data.character.weap_unit_names[table.random_key(tweak_data.character.weap_unit_names)]
	local equipped_w_selection = self._unit:inventory():equipped_selection()
	if equipped_w_selection then
		self._unit:inventory():remove_selection(equipped_w_selection, true)
	end
	TeamAIInventory.add_unit_by_name(self._unit:inventory(), new_weapon_ids, true)
	local _ = weapon and self._unit:inventory():add_unit_by_factory_name(weapon, false, false, nil, "")
	local weapon_unit = self._unit:inventory():equipped_unit()
	weapon_unit:base():add_damage_multiplier(damage_multiplier)
end)