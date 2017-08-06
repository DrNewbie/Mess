if Global.game_settings.level_id ~= "chill" then
	return
end
Hooks:PostHook(CopDamage, "init", "CopDamageinit_Backstab", function(copp, ...)
	if copp.immortal then
		if copp._unit:base()._tweak_table == "robbers_safehouse" then
			copp.immortal = false
			copp:set_invulnerable(false)
		end
	end
end )