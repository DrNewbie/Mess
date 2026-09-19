local old = CopDamage.damage_bullet

function CopDamage:damage_bullet(__attack_data, ...)
	local __result = old(self, __attack_data, ...)
	local __is_civilian = CopDamage.is_civilian(self._unit:base()._tweak_table)
	if __attack_data.weapon_unit and __attack_data.weapon_unit:base() then
		if type(__result) == "table" and type(__result.type) == "string" and __result.type == "death" and __attack_data.attacker_unit == managers.player:player_unit() then
			if not __is_civilian and managers.player:has_category_upgrade("temporary", "overkill_damage_multiplier") and table.contains(__attack_data.weapon_unit:base()._blueprint, "wpn_fps_upg_a_grenade_launcher_hornet") then
				managers.player:activate_temporary_upgrade("temporary", "overkill_damage_multiplier")
			end
		end
	end
	return __result
end