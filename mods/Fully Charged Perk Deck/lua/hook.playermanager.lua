Hooks:PreHook(PlayerManager, "on_headshot_dealt", "CheckFullyChargedKilled", function(self)
	local player_unit = self:player_unit()
	if player_unit and self:has_category_upgrade("player", "passive_fully_charged_invulnerable") then
		local damage_ex = player_unit:character_damage()
		if damage_ex and not damage_ex:arrested() and not damage_ex:need_revive() then
			damage_ex:set_fully_charged_invulnerable(true)
			damage_ex:restore_health(3, true)
		end
	end
end)