Hooks:PostHook(WeaponTweakData, "_init_new_weapons", "F_"..Idstring("Sniper does lower damage in close range:WeaponTweakData:_init_new_weapons"):key(), function(self)
	for __i, __d in pairs(self) do
		if type(__d) == "table" and type(__d.damage_falloff) == "table" and type(__d.categories) == "table" and table.contains(__d.categories, "snp") then
			self[__i].damage_falloff.near_multiplier = self[__i].damage_falloff.near_multiplier * 0.5
		end
	end
end)