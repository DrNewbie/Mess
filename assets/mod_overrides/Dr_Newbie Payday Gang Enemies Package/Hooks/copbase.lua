local DrNewbieEnemiesOverrides_default_weapon_name = CopBase.default_weapon_name

function CopBase:default_weapon_name(...)
	if self._new_default_weapon_unit_name then
		return Idstring(self._new_default_weapon_unit_name)
	end
	return DrNewbieEnemiesOverrides_default_weapon_name(self, ...)
end