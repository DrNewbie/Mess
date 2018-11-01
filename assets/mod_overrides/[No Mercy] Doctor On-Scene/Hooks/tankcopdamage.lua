function TankCopDamage:heal_unit(unit, override_cooldown)
	if not self._unit:base()._medic_now then
		return false
	end
	return CopDamage.heal_unit(self, unit, override_cooldown)
end