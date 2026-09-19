Hooks:PreHook(PlayerManager, "activate_temporary_upgrade", "F_"..Idstring("PreHook:PlayerManager:activate_temporary_upgrade:Gambler Perk Deck Buff"):key(), function(self, category, upgrade)
	if category == "temporary" and upgrade == "loose_ammo_restore_health" and not self:has_activate_temporary_upgrade("temporary", "loose_ammo_restore_health") then
		local upgrade_value = self:upgrade_value(category, upgrade)
		if upgrade_value == 0 then
		
		else
			if self:player_unit() and not self:player_unit():character_damage():dead() then
				local damage_ext = self:player_unit():character_damage()
				if damage_ext then
					damage_ext:_calc_health_damage({damage = 1, variant = "melee"})
				end
			end
		end
	end
end)