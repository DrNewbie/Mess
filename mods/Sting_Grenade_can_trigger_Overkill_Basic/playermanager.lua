local old = PlayerManager.temporary_upgrade_value

function PlayerManager:temporary_upgrade_value(__category, __upgrade, ...)
	local __result = old(self, __category, __upgrade, ...)
	if __category == "temporary" and __upgrade == "dmg_multiplier_outnumbered" then
		if self:has_activate_temporary_upgrade("temporary", "overkill_damage_multiplier") then
			local weapon_unit = self:equipped_weapon_unit()
			if weapon_unit and weapon_unit:base() and table.contains(weapon_unit:base()._blueprint, "wpn_fps_upg_a_grenade_launcher_hornet") then
				__result = __result * self:temporary_upgrade_value("temporary", "overkill_damage_multiplier", 1)
			end			
		end
	end
	return __result
end