local mod_ids = Idstring("L4D2 Pain Reliever"):key()
local func1 = "F_"..Idstring("func1::"..mod_ids):key()

Hooks:PreHook(FirstAidKitBase, 'take', func1, function(self, unit)
	if not self._empty and unit and unit:character_damage() then
		local unit_dmg = unit:character_damage()
		unit_dmg:l4d2_pain_reliever_delay_damage(0.25, (1-(1-unit_dmg:health_ratio())*0.5))
	end
end)