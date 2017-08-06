Hooks:PostHook(CopDamage, "init", "CopDamageinit_MCC", function(copp, ...)
	if copp.immortal then
		if copp._unit:base()._tweak_table == "robbers_safehouse" then
			copp.immortal = false
			copp:set_invulnerable(false)
		end
	end
end )