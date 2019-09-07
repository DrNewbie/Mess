Hooks:PostHook(NewRaycastWeaponBase, "replenish", "F_"..Idstring("NewRaycastWeaponBase:replenish:DewmSlayaLASBoosts"):key(), function(self)
	if managers.player:Is_LAS_DewmSlaya() then
		local ammax = self:get_ammo_max() * 2
		self:set_ammo_max(ammax)
		self:set_ammo_max_per_clip(ammax)
		self:set_ammo_total(ammax)
		self._is_dewmslaya = true
	end
end)

Hooks:PostHook(NewRaycastWeaponBase, "add_ammo", "F_"..Idstring("NewRaycastWeaponBase:add_ammo:DewmSlayaLASBoosts"):key(), function(self)
	if self._unit and alive(self._unit) and managers.player:Is_LAS_DewmSlaya() and self:can_reload() then
		self:on_reload()
	end
end)