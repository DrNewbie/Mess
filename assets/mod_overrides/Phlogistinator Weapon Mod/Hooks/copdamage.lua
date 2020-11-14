local mod_ids = Idstring("Phlogistinator Weapon Mod"):key()
local is_mod = "F_"..Idstring("is_mod:"..mod_ids):key()
local func2 = "F_"..Idstring("func2:"..mod_ids):key()
local func3 = "F_"..Idstring("func3:"..mod_ids):key()
local func4 = "F_"..Idstring("func4:"..mod_ids):key()
local func5 = "F_"..Idstring("func5:"..mod_ids):key()
local func6 = "F_"..Idstring("func6:"..mod_ids):key()
local func7 = "F_"..Idstring("func7:"..mod_ids):key()
local func40 = "F_"..Idstring("func40:"..mod_ids):key()

Hooks:PreHook(CopDamage, "damage_fire", func2, function(self, attack_data)
	if not attack_data[func3] and attack_data.weapon_unit and attack_data.weapon_unit:base()[func6] and attack_data.weapon_unit and attack_data.weapon_unit.base and attack_data.weapon_unit:base()[is_mod] then
		attack_data[func3] = true
		local critical_hits = self._char_tweak.critical_hits or {}
		local critical_damage_mul = critical_hits.damage_mul or 1.5
		local __old_damage = attack_data.damage
		local __damage_gain = math.max(__old_damage * critical_damage_mul - __old_damage, 0)
		attack_data.damage = __damage_gain
		self:damage_fire(attack_data)
		attack_data.__old_damage = __old_damage
		managers.hud:on_crit_confirmed()
	end
end)

Hooks:PostHook(CopDamage, "damage_fire", func4, function(self, attack_data)
	if attack_data.weapon_unit and attack_data.weapon_unit.base and attack_data.weapon_unit:base()[is_mod] then
		if not attack_data.weapon_unit:base()[func6] then
			attack_data.weapon_unit:base()[func5] = attack_data.weapon_unit:base()[func5] or 0
			attack_data.weapon_unit:base()[func5] = attack_data.weapon_unit:base()[func5] + attack_data.damage
			if not attack_data.weapon_unit:base()[func40] and attack_data.weapon_unit:base()[func5] > 1000 then
				attack_data.weapon_unit:base()[func40] = true
				managers.player:local_player():sound_source():post_event("pyro_laughlong01")
			end
		else
			if attack_data.weapon_unit:base()[func7] < managers.player:player_timer():time() then
				attack_data.weapon_unit:base()[func6] = nil
				attack_data.weapon_unit:base()[func5] = 0
			end
		end
	end
end)